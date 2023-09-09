class Users::Otp::AuthController < DeviseController
  include ::TwoFactorAuthenticable
  prepend_before_action :require_no_authentication, only: %i[new create]

  def new
    authorize_otp_session!
    self.resource = User.find_by(id: session[:otp_resource_id])
    return unless resource.nil?

    clear_otp_session
    redirect_to new_user_session_path
  end

  def create
    authorize_otp_session!
    if session_expired?
      redirect_to new_user_session_path
    else
      resource = warden.authenticate!(
        :otp_attempt_authenticatable,
        {
          scope: resource_name,
          recall: "#{controller_path}#new"
        }
      )
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end