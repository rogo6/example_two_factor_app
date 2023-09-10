class User < ApplicationRecord
  TWILIO_PHONE_REGEX = /^\+[1-9]\d{1,14}$/.freeze

  devise :two_factor_authenticatable, :registerable, :recoverable, :validatable, :lockable

  enum two_factor_auth_method: { sms: 0, email: 1, authenticator: 2 }, _suffix: true

  validates :email, presence: true
  validates :two_factor_auth_method, inclusion: { in: User.two_factor_auth_methods.keys }
  validate :valid_phone

  def last_attempt?
    failed_attempts == self.class.maximum_attempts - 1
  end

  def two_factor_qr_code_uri
    otp_provisioning_uri(email, issuer: 'Example 2FA App')
  end

  private

  def generate_otp_secret!
    return if otp_secret.present?

    update!(otp_secret: User.generate_otp_secret)
  end

  def sms_auth_method?
    two_factor_auth_method == 'sms'
  end

  def valid_phone
    return unless sms_auth_method?
    return if phone_number&.match(TWILIO_PHONE_REGEX)

    errors.add(:phone_number, :invalid)
  end
end
