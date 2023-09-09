module TwoFactorAuthenticable
  extend ActiveSupport::Concern

  included do
    def clear_otp_session
      session[:otp_resource_id] = nil
      session[:otp_send_method] = nil
    end

    def clear_otp_session_expiry
      session[:otp_resource_id_expires_at] = nil
    end

    def update_otp_session_resource_id(value)
      session[:otp_resource_id] = value
    end

    def update_otp_resource_expiry
      session[:otp_resource_id_expires_at] = 2.minutes.from_now
    end

    def update_otp_send_method(value)
      session[:otp_send_method] = value
    end

    def session_expired?
      session[:otp_resource_id_expires_at].nil? || session[:otp_resource_id_expires_at] < Time.current
    end

    def authorize_otp_session!
      return unless session[:otp_resource_id]
      return unless session[:otp_resource_id_expires_at]
      return unless session[:otp_resource_id_expires_at] < Time.current

      clear_otp_session
      clear_otp_session_expiry
    end
  end
end