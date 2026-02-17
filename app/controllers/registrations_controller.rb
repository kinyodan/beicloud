# frozen_string_literal: true

# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  # If you ever need to permit additional fields during sign-up or update,
  # Do NOT remove the Devise defaults — just append.

  private

  # Overrides Devise's default sign-up permitted parameters
  def sign_up_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  # Overrides Devise's default account update permitted parameters
  # (includes :current_password for password changes)
  def account_update_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :current_password
    )
  end

end