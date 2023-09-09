class Users::SessionsController < Devise::SessionsController
  include ::TwoFactorAuthenticable
  def new
    clear_otp_session
    super
  end

  def create
    self.resource = warden.authenticate!(:database_authenticatable, auth_options)

    if otp_required_for_login?
      sign_out(resource)
      update_otp_session_resource_id(resource.id)
      update_otp_resource_expiry
      update_otp_send_method(::GenerateTwoFactorAuthCodeCommand.call(resource))
      redirect_to users_sign_in_otp_path
    else
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  def regenerate_two_factor_code
    resource = User.find(session[:otp_resource_id])
    update_otp_send_method(::GenerateTwoFactorAuthCodeCommand.call(resource))
    redirect_to request.referer
  end

  private

  def otp_required_for_login?
    User.find_by(id: resource.id)&.otp_required_for_login?
  end
end