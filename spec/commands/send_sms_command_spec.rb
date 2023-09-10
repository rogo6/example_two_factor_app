require 'rails_helper'

RSpec.describe SendSmsCommand do
  let(:command) { SendSmsCommand.new(user) }

  describe '#call' do
    context 'with valid twilio number' do
      let(:user) { User.new(otp_secret: User.generate_otp_secret, phone_number: '+48123456789') }

      it 'sends an SMS using Twilio' do
        VCR.use_cassette('users/send_sms_success') do
          expect { command.call }.not_to raise_error
        end
      end
    end

    context 'with invalid twilio number' do
      let(:user) { User.new(otp_secret: User.generate_otp_secret, phone_number: '222 333 41') }

      it 'raises an error if Twilio client initialization fails' do
        VCR.use_cassette('users/send_sms_failure') do
          allow(Twilio::REST::Client).to receive(:new).and_raise(Twilio::REST::TwilioError)
          expect { command.call }.to raise_error(Twilio::REST::TwilioError)
        end
      end
    end
  end
end