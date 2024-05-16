# frozen_string_literal: true

require 'cgi'
require 'net/http'
require 'zlib'

class ApplicationController < ActionController::Base
  include ServicesManager
  before_action :set_beispace_cookies
  before_action :verify_authentication
  before_action :set_beispace
  before_action :deployment_logs

  layout :layout_by_resource

  add_breadcrumb 'home', :root_path
  add_breadcrumb 'beiapps', :beiapps_path

  def set_stack_icons
    #  @stack_icons = {javscript: "<i class='fa-brands fa-square-js'></i>", nodejs: }
  end

  def deployment_logs
    @staging_deployment_logs = 'start-logs'
    @deployment_logs = 'start-logs'
  end

  def set_beispace_cookies
    return unless params[:beispace]

    p 'Beispace cookie set' if authentication_set_Beispace_cookies(params[:beispace])
  end

  def verify_authentication
    url_encoded_string = CGI.escape(request.url)
    uri = URI.parse(request.url)

    if request.cookies['beispace_current_user'] && request.cookies['beispace_current_user']['token']
      sessionid_cookie_set = request.cookies['beispace_current_user']
      @beispace_current_user = request.cookies['beispace_current_user']
      redirect_to uri.path if params[:s]
    else
      AuthenticationDataProcessor.new(params).authentication_redirector

    end
  end

  protected

  def layout_by_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  private

  def set_beispace
    if cookies['beispace']
      @beispace = cookies['beispace']
    else
      #    redirect_to root_url
    end
  end

  def encrypt(payload, salt, algo = 'HS256')
    JWT.encode payload, salt, algo
  end

  def decrypt(token, salt, algo = 'HS256')
    decrypted_token = JWT.decode token, salt, algo
    begin
      decrypted_token.first.deep_symbolize_keys
    rescue StandardError
      {}
    end
  end
end
