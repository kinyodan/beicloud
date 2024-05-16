module CookiesManagerService

  def authentication_set_auth_cookies(auth_data)
    cookies[:beispace_current_user] = {
      value: auth_data,
      expires: 1.year.from_now,
      domain: 'beicloud.com',
      secure: false,
      httponly: false
    }
    true
  rescue Exception
    error_notice = { data: nil,
                     message: 'Error::Exception::Problem Writting cookie data -- source=> cartServicesConcernWriteCookieData' }
    p error_notice
    false
  end

  def authentication_set_Beispace_cookies(cookie_data)
    cookies[:beispace] = {
      value: cookie_data,
      expires: 1.year.from_now,
      domain: 'beicloud.com',
      secure: false,
      httponly: false
    }
    true
  rescue Exception
    error_notice = { data: nil,
                     message: 'Error::Exception::Problem Writting cookie data -- source=> cartServicesConcernWriteCookieData' }
    p error_notice
    false
  end

  def authentication_setting_repo_urlcookie(cookie_data)
    cookies[:git_repos_url] = {
      value: cookie_data,
      expires: 1.year.from_now,
      domain: 'beicloud.com',
      secure: false,
      httponly: false
    }
    true
  rescue Exception
    error_notice = { data: nil,
                     message: 'Error::Exception::Problem Writting cookie data -- source=> authentication_setting_repo_urlcookie' }
    p error_notice
    false
  end

end 