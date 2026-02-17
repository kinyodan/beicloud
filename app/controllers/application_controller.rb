# frozen_string_literal: true

require 'cgi'
require 'net/http'
require 'zlib'
require 'jwt'  

class ApplicationController < ActionController::Base
  include ServicesManager
  include Pagy::Backend  

  helper Pagy::Frontend

  before_action :verify_authentication
  before_action :set_beispace_cookies
  before_action :set_beispace
  before_action :deployment_logs

  layout :layout_by_resource

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'BeiApps', :beiapps_path

  def set_stack_icons
    # TODO: Implement proper stack icon mapping
    # @stack_icons = {
    #   javascript: "<i class='fa-brands fa-square-js'></i>",
    #   nodejs: "<i class='fa-brands fa-node-js'></i>",
    # }
  end

  private

  def deployment_logs
    # TODO: Replace hardcoded strings with real log fetching logic
    @staging_deployment_logs = 'start-logs'
    @deployment_logs = 'start-logs'
  end

  def set_beispace_cookies
    return unless params[:beispace].present?

    if authentication_set_Beispace_cookies(params[:beispace])
      Rails.logger.debug { "Beispace cookie set for: #{params[:beispace]}" }
    end
  end

  def verify_authentication
    # Early return if already authenticated via cookie
    if current_beispace_user.present?
      redirect_to request.path if params[:s].present? 
      return
    end

    # Handle unauthenticated
    AuthenticationDataProcessor.new(params).authentication_redirector
  end

  def set_beispace
    @beispace = cookies['beispace']

    # to enforce beispace presence
    redirect_to root_path unless @beispace.present?
  end

  # JWT Helpers – moved to private as they're utility methods
  def encode_token(payload, secret, algorithm = 'HS256')
    JWT.encode(payload, secret, algorithm)
  end

  def decode_token(token, secret, algorithm = 'HS256')
    JWT.decode(token, secret, true, algorithm: algorithm).first.deep_symbolize_keys
  rescue JWT::DecodeError, StandardError
    {}  
  end

  # Helper to access current user from cookie
  def current_beispace_user
    @beispace_current_user ||= begin
      cookie_data = request.cookies['beispace_current_user']
      cookie_data.present? ? cookie_data : nil
    end
  end

  protected

  def layout_by_resource
    devise_controller? ? 'devise' : 'application'
  end
end