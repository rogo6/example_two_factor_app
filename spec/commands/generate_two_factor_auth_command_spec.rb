require 'rails_helper'

RSpec.describe GenerateTwoFactorAuthCodeCommand do
  let(:user) { User.new(otp_secret: User.generate_otp_secret) }
  subject { described_class.new(user) }

  describe '#call' do
    context 'when two-factor auth method is authenticator' do
      it 'returns :authenticator' do
        allow(user).to receive(:authenticator_two_factor_auth_method?).and_return(true)
        expect(subject.call).to eq(:authenticator)
      end
    end

    context 'when two-factor auth method is SMS and phone number is valid' do
      it 'returns :sms' do
        allow(user).to receive(:authenticator_two_factor_auth_method?).and_return(false)
        allow(subject).to receive(:valid_twilio_number?).and_return(true)
        expect(SendSmsCommand).to receive(:call).with(user)
        expect(subject.call).to eq(:sms)
      end
    end

    context 'when two-factor auth method is SMS but phone number is invalid' do
      it 'returns :email' do
        allow(user).to receive(:authenticator_two_factor_auth_method?).and_return(false)
        allow(subject).to receive(:valid_twilio_number?).and_return(false)
        expect(DeviseMailer).to receive(:send_two_factor_code).with(user).and_return(double(deliver_now: true))
        expect(subject.call).to eq(:email)
      end
    end

    context 'when an error occurs during SMS sending' do
      it 'returns :email' do
        VCR.use_cassette('users/send_sms_failure') do
          allow(user).to receive(:authenticator_two_factor_auth_method?).and_return(false)
          allow(subject).to receive(:valid_twilio_number?).and_return(true)
          expect(DeviseMailer).to receive(:send_two_factor_code).with(user).and_return(double(deliver_now: true))
          expect(subject.call).to eq(:email)
        end
      end
    end
  end

  describe '#valid_twilio_number?' do
    it 'returns true for a valid Twilio phone number' do
      user.phone_number = '+1234567890123'
      expect(subject.send(:valid_twilio_number?)).to be_truthy
    end

    it 'returns false for an invalid Twilio phone number' do
      user.phone_number = 'invalid_phone'
      expect(subject.send(:valid_twilio_number?)).to be_falsey
    end
  end
end
