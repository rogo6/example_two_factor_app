module Devise
  module Strategies
    class OtpAttemptAuthenticatable < Devise::Strategies::Base

      def authenticate!
        resource = mapping.to.find(session[:otp_resource_id])
        if validate_otp(resource)
          session[:otp_resource_id] = nil
          session[:otp_resource_id_expires_at] = nil
          success!(resource)
        else
          handle_invalid_authenticate(resource)
        end
      end

      private

      def validate_otp(resource)
        return if params[scope]['otp_attempt'].nil?

        resource.validate_and_consume_otp!(params[scope]['otp_attempt'])
      end

      def handle_invalid_authenticate(resource)
        resource.increment!(:failed_attempts)
        resource.lock_access! if resource.failed_attempts >= 10
        if resource.last_attempt?
          fail!('Your account will be locked after next failed attempt')
        elsif resource.access_locked?
          session[:otp_resource_id] = nil
          session[:otp_resource_expires_at] = nil
          fail!('Your account is locked now')
        else
          fail!('Invalid two factor auth code')
        end
      end
    end
  end
end

Warden::Strategies.add(:otp_attempt_authenticatable, Devise::Strategies::OtpAttemptAuthenticatable)