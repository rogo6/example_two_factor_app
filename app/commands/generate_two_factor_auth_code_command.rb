class GenerateTwoFactorAuthCodeCommand
  extend BaseCommand

  def initialize(user)
    @user = user
  end

  def call
    return :authenticator if user.authenticator_two_factor_auth_method?

    if valid_twilio_number?
      SendSmsCommand.call(user)
      :sms
    else
      DeviseMailer.send_two_factor_code(user).deliver_now
      :email
    end
  rescue Twilio::REST::RestError
    DeviseMailer.send_two_factor_code(user).deliver_now
    :email
  end

  private

  attr_reader :user

  def valid_twilio_number?
    user.phone_number&.match User::TWILIO_PHONE_REGEX
  end
end