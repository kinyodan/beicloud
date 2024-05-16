# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    redirect_to "#{ENV['BEIMARKET_URL']}/users/sign_in?src=beicloud", allow_other_host: true
  end

  def auth
    p 'redirected from github beicloud app'
  end

  def delete
    return unless authentication_set_auth_cookies('null') && authentication_set_Beispace_cookies('null')

    redirect_to "#{ENV['BEIMARKET_URL']}/?src=beicloud&act=logout", allow_other_host: true
  end
end
