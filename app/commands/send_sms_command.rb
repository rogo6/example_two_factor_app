class SendSmsCommand
  extend BaseCommand

  def initialize(resource)
    @resource = resource
  end

  def call
    client.messages.create(
      from: ENV.fetch('TWILIO_PHONE_NUMBER', nil),
      to: resource.phone_number,
      body: "Your six digit code: #{resource.current_otp}"
    )
  end

  private

  attr_reader :resource

  def client
    @client ||= ::Twilio::REST::Client.new
  end
end