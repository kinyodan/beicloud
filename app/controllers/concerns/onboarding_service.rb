# frozen_string_literal: true
require 'octokit'
require 'open3'
require "zlib"

module OnboardingService
  extend ActiveSupport::Concern

  TERMINAL_HEADER = "########\n BeiCloud Deployment ########\n"

  def onboarding_import_from_github(access_token, _owner, _repo, _path_to_file)
      client = Octokit::Client.new(access_token: access_token)
      return false unless client && client.repos
         repos = client.repos.select { |r| r[:id] == 63_977_794 }
         client.repos
  end 

  def onboarding_get_branches_and_Deploy(repo, dir_name, onboarding_id, beiapp_id)
      # start updating the current onboarding with current deployment id
      beiapp = Beiapp.where(id: beiapp_id).first
      onboarding = Onboarding.where(id: onboarding_id).first
      current_deployment = Deployment.where(onboarding_id: onboarding_id).first
      update_onboarding = onboarding.update_columns(current_deployment_id: current_deployment.id)
      if update_onboarding
          p "update_onboarding done--"
      end 
      # end updating the current onboarding with current deployment id

      beicloud_icon = "<i class='fa-solid fa-cloud'></i>"
      Timeout.timeout 5 do
      end 
      source_git_processing(dir_name, beicloud_icon, repo)
      deployment_directory_processing_and_staging(dir_name, beicloud_icon, repo)
      if system("app003-#{dir_name}")
         ActionCable.server.broadcast(dir_name, { status: true, body: "#{Time.now}:@beicloud: Setting up app name --> app003-#{dir_name} " })
      end  
      setup_deployment_environment(dir_name, beicloud_icon, repo)

      
      create_app_in_deployment_environment(dir_name, beicloud_icon, repo)
      @compressed_staging_log_data = Zlib::Deflate.deflate(@staging_deployment_logs)
      update_deployment_status = current_deployment.update_columns(status: "Deployment initiated not completed")
      if update_deployment_status
         p "update_deployment_status done"
      end 

      app_deployment(dir_name, beicloud_icon, repo)
      @compressed_log_data = Zlib::Deflate.deflate(@deployment_logs)

      logs = { staging: @compressed_staging_log_data, deployment: @compressed_log_data }.to_s
      update_deployment_Body = current_deployment.update_columns(body: logs, status: "Deployment initiated and succesfully deployed")
      if update_deployment_Body
          p "update_deployment_Body done"
      end 
      ActionCable.server.broadcast(dir_name, { status: "finished", body: "#{Time.now}:@beicloud: Deploying app successfully completed --> app003-#{dir_name} " })
  end 

  private

  def source_git_processing(dir_name, _beicloud_icon, repo)
      ActionCable.server.broadcast(dir_name, { status: "finished", body: (TERMINAL_HEADER).to_s })
      stream_terminal_output("rm -rf ../#{dir_name}", dir_name,{ status: true, body: "#{Time.now}:@beicloud: Starting deployment" })
      stream_terminal_output("git clone #{repo} ../#{dir_name}", dir_name, { status: true, body: "#{Time.now}:@beicloud: Starting deployment" })
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && pwd", dir_name, { status: true, body: "#{Time.now}:@beicloud: Starting deployment" })
  end 

  def deployment_directory_processing_and_staging(dir_name, _beicloud_icon, _repo)
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && dir", dir_name,{ status: true, body: "#{Time.now}:@beicloud: changing directory to staged DIR" })
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && git add . && dir", dir_name, { status: true, body: "#{Time.now}:@beicloud: Adding git commits to staged repo" })
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && git add . && dir", dir_name, { status: true, body: "#{Time.now}:@beicloud: Adding git commits to staged repo" })
      stream_terminal_output(" cd /home/me/dev/dev3/beicloud/#{dir_name} && git commit -m 'commit for deploy to dokku' && dir ", dir_name, { status: true, body: "#{Time.now}:@beicloud: Commiting for deploy " })
      stream_terminal_output("git fetch --all", dir_name, { status: true, body: "#{Time.now}:@beicloud: Fetching from repo " })
      stream_terminal_output("git branch --all ", dir_name, { status: true, body: "#{Time.now}:@beicloud: Staging branch  " })
  end 

  def setup_deployment_environment(dir_name, _beicloud_icon, _repo)
      ActionCable.server.broadcast(dir_name, { status: true, body: "#{Time.now}:@beicloud: Starting Clearing app staging environment --> app003-#{dir_name} " })
      stream_terminal_output("echo '@Confucius@me2' | sudo -S dokku --force apps:destroy app003-#{dir_name}", dir_name, { status: true, body: "#{Time.now}:@beicloud: Starting Clearing app staging environment --> app003-#{dir_name} " })
      ActionCable.server.broadcast(dir_name, { status: true, body: "#{Time.now}:@beicloud: #{system('ls')} --> app003-#{dir_name} " })
      stream_terminal_output("echo '@Confucius@me2' | sudo -S dokku apps:create app003-#{dir_name}", dir_name, { status: true, body: "#{Time.now}:@beicloud: creating app on staged environment --> app003-#{dir_name} " })
      stream_terminal_output("sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git", dir_name, { status: true, body: "#{Time.now}:@beicloud: Installing posgres on staged environment --> app003-#{dir_name} " })
  end 

  def create_app_in_deployment_environment(dir_name, _beicloud_icon, _repo)
      radnm = SecureRandom.hex(10)
      db_name = "#{SecureRandom.hex(10)}db#{dir_name}"
      stream_terminal_output("sudo dokku postgres:create #{db_name}", dir_name, { status: true, body: "#{Time.now}:@beicloud: creating app database --> app003-#{dir_name} " })
      stream_terminal_output("sudo dokku postgres:link #{db_name} app003-#{dir_name}", dir_name, { status: true, body: "#{Time.now}:@beicloud: Attaching database to app --> app003-#{dir_name}" })
      stream_terminal_output("sudo dokku git:initialize app003-#{dir_name}", dir_name,{ status: true, body: "#{Time.now}:@beicloud: Initializing app git repository app --> app003-#{dir_name}" })
      ActionCable.server.broadcast(dir_name, { status: true, body: "#{Time.now}:@beicloud: #{system('ls')} --> app003-#{dir_name} " })
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && git remote remove dokku", dir_name,{ status: true, body: "#{Time.now}:@beicloud: setting up remote origin --> app003-#{dir_name} " })
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && git remote add dokku dokku@beicloud.com:app003-#{dir_name}", dir_name, { status: true, body: "#{Time.now}:@beicloud: adding remote origin to app staging environment --> app003-#{dir_name} " })
  end     

  def app_deployment(dir_name, _beicloud_icon, _repo)
      ActionCable.server.broadcast(dir_name, { status: true, body: "#{Time.now}:@beicloud: Starting deployment to staged environment --> app003-#{dir_name} " })
      stream_terminal_output("cd /home/me/dev/dev3/beicloud/#{dir_name} && git push dokku master", dir_name, { status: true, body: "#{Time.now}:@beicloud: Deploying app --> app003-#{dir_name} " }, "deploy")
  end 

  def stream_terminal_output(cmd, dir_name, initial_messege, process = "staging")
      exceptions_text = { "Unlinking": true, "retire": true }
      ActionCable.server.broadcast(dir_name, initial_messege)
      Open3.popen3(cmd) do |_stdin, stdout, _stderr, _wait_thr|
          while (line = stdout.gets)
              if line.include? "dokku"
                 line["dokku"] = "beicloud"
              end 
                             line.include? "retire"
                if process == "staging"
                   @staging_deployment_logs = @staging_deployment_logs + "<!~!>" + line 
                end

                if process == "deploy"
                   @deployment_logs = @deployment_logs + "<!~!>" + line
                end 
                ActionCable.server.broadcast(dir_name, { status: true, body: "#{Time.now}:@beicloud: #{line} --> app003-#{dir_name} " })
              end
          end
      end
  end 
end
