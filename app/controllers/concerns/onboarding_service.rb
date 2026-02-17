# frozen_string_literal: true

module OnboardingService
  extend ActiveSupport::Concern

  DEPLOY_APP_PREFIX = "beiapp-".freeze
  WORK_DIR_BASE     = Rails.root.join("tmp", "deployments").freeze 

  # Called from GitDeploymentJob.perform_later(...)
  def self.perform_deployment(onboarding_id:, beiapp_id:, repo_url:, access_token:)
    new(onboarding_id:, beiapp_id:, repo_url:, access_token:).perform
  end

  def initialize(onboarding_id:, beiapp_id:, repo_url:, access_token:)
    @onboarding    = Onboarding.find(onboarding_id)
    @beiapp        = Beiapp.find(beiapp_id)
    @repo_url      = repo_url
    @access_token  = access_token
    @channel       = "deployment_#{beiapp_id}_#{onboarding_id}"
    @logs          = { staging: +"", deployment: +"" }
  end

  def perform
    update_status("initiated")

    dir_name = "#{DEPLOY_APP_PREFIX}#{@beiapp.id}-#{SecureRandom.hex(6)}"
    full_path = WORK_DIR_BASE.join(dir_name)

    FileUtils.mkdir_p(WORK_DIR_BASE)

    broadcast("Starting deployment for #{@beiapp.name} → #{dir_name}")

    begin
      clone_repository(full_path)
      prepare_staging(full_path)
      setup_dokku_app(dir_name)
      push_to_dokku(full_path, dir_name)

      update_status("deployed")
      broadcast("Deployment completed successfully", status: "finished")
    rescue StandardError => e
      update_status("failed", error_message: e.message)
      broadcast("Deployment failed: #{e.message}", status: "failed")
      Rails.logger.error("Deployment failed for BeiApp #{@beiapp.id}: #{e.message}\n#{e.backtrace.join("\n")}")
      cleanup_on_failure(full_path, dir_name)
    ensure
      save_compressed_logs
    end
  end

  private

  def broadcast(message, status: true)
    ActionCable.server.broadcast(@channel, { status:, body: "[#{Time.current}] @beicloud: #{message}" })
  end

  def update_status(status, error_message: nil)
    @onboarding.update_columns(status:)
    current_deployment&.update_columns(status:, error_message:)
  end

  def current_deployment
    @current_deployment ||= Deployment.find_by(onboarding: @onboarding)
  end

  def clone_repository(path)
    broadcast("Cloning repository...")
    run_command("git clone #{@repo_url} #{path}", chdir: WORK_DIR_BASE)
  end

  def prepare_staging(path)
    broadcast("Preparing staging directory...")
    Dir.chdir(path) do
      run_command("git add .")
      run_command("git commit -m 'Deployment commit [skip ci]' --allow-empty || true")
    end
  end

  def setup_dokku_app(app_name)
    broadcast("Setting up Dokku app: #{app_name}")

    run_command("dokku apps:destroy #{app_name} --force || true")
    run_command("dokku apps:create #{app_name}")

    # Database example (make configurable per stack)
    db_name = "db-#{app_name}"
    run_command("dokku postgres:create #{db_name}")
    run_command("dokku postgres:link #{db_name} #{app_name}")
  end

  def push_to_dokku(path, app_name)
    broadcast("Pushing to Dokku remote...")
    Dir.chdir(path) do
      run_command("git remote remove dokku || true")
      run_command("git remote add dokku dokku@#{dokku_host}:#{app_name}")
      run_command("git push dokku master:main --force")
    end
  end

  def run_command(cmd, chdir: nil, &block)
    Dir.chdir(chdir || WORK_DIR_BASE) do
      stdout_str, stderr_str, status = Open3.capture3(cmd)

      output = stdout_str + stderr_str
      output.each_line do |line|
        cleaned = line.gsub(/dokku/i, "beicloud").strip
        broadcast(cleaned)
        yield cleaned if block_given?
      end

      raise "Command failed: #{cmd}\n#{stderr_str}" unless status.success?
    end
  end

  def cleanup_on_failure(path, app_name)
    FileUtils.rm_rf(path) rescue nil
    run_command("dokku apps:destroy #{app_name} --force || true") rescue nil
  end

  def save_compressed_logs
    compressed = Zlib::Deflate.deflate(@logs.values.join("\n"))
    current_deployment&.update_columns(body: compressed)
  end

  def dokku_host
    ENV.fetch("DOKKU_HOST", "beicloud.com")
  end
end