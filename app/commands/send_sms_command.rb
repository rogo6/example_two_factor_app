class SendSmsCommand
  extend BaseCommand

  def initialize(user)
    @user = user
  end

  def call
    client.messages.create(
      from: ENV.fetch('TWILIO_PHONE_NUMBER', nil),
      to: user.phone_number,
      body: "Your six digit code: #{user.current_otp}"
    )
  end

  private

  attr_reader :user

  def client
    @client ||= ::Twilio::REST::Client.new
  end
end