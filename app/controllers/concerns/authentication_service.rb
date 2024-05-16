# frozen_string_literal: true

module AuthenticationService
  include CookiesManagerService
  extend ActiveSupport::Concern

  class AuthenticationDataProcessor(aut_params)
    def initialize
       @aut_params = aut_params 
        
    end 

    def authentication_redirector
      if @aut_params[:s]
        response_body = request_verify_authentication(@aut_params[:s],@aut_params)

        if response_body['status']
          if authentication_set_auth_cookies(@aut_params[:s])
            redirect_to '/'
          else
            redirect_to "#{ENV['BEIMARKET_URL']}/users/sign_in?src=beicloud", allow_other_host: true
          end

        else
          redirect_to "#{ENV['BEIMARKET_URL']}/users/sign_in?src=beicloud", allow_other_host: true

        end

      else
        unless controller_name == 'home'
          redirect_to "#{ENV['BEIMARKET_URL']}/users/sign_in?src=beicloud", allow_other_host: true
        end

      end
    end
  end

end
