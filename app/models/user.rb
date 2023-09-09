class User < ApplicationRecord
  TWILIO_PHONE_REGEX = /^\+[1-9]\d{1,14}$/.freeze

  devise :two_factor_authenticatable, :registerable, :recoverable, :validatable, :lockable

  enum two_factor_auth_method: { sms: 0, email: 1, authenticator: 2 }, _suffix: true

  def last_attempt?
    failed_attempts == self.class.maximum_attempts - 1
  end

  def two_factor_qr_code_uri
    otp_provisioning_uri(email, issuer: 'Example 2FA App')
  end
end
