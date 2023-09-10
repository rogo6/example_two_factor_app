require 'rails_helper'

RSpec.describe Users::UpdateForm, type: :model do
  let(:user) { User.new }
  let(:form) { described_class.new(user) }

  context 'with valid attributes' do
    let(:attr) { { email: 'test@example.com', phone_number: '', otp_required_for_login: true, two_factor_auth_method: 'authenticator' } }

    it 'is valid' do
      expect(form.validate(attr)).to be_truthy
    end

    it 'saves the form and generates OTP secret' do
      expect(user).to receive(:update!).with(hash_including(:otp_secret)).once
      form.save_form(attr)
    end
  end

  context 'with invalid two-factor auth method' do
    let(:attr) { { email: 'test@example.com', phone_number: '', otp_required_for_login: true, two_factor_auth_method: 'invalid_method' } }

    it 'is invalid' do
      expect(form.validate(attr)).to be_falsey
    end

    it 'does not save the form or generate OTP secret' do
      expect(user).not_to receive(:update!)
      form.save_form(attr)
    end
  end

  context 'without email' do
    let(:attr) { { email: nil, phone_number: '', otp_required_for_login: true, two_factor_auth_method: 'authenticator' } }

    it 'is invalid' do
      expect(form.validate(attr)).to be_falsey
    end

    it 'does not save the form or generate OTP secret' do
      expect(user).not_to receive(:update!)
      form.save_form(attr)
    end
  end

  context 'with valid phone number for SMS auth' do
    let(:attr) { { email: 'test@example.com', phone_number: '+1234567890123', otp_required_for_login: true, two_factor_auth_method: 'sms' } }

    it 'is valid' do
      expect(form.validate(attr)).to be_truthy
    end
  end

  context 'with invalid phone number for SMS auth' do
    let(:attr) { { email: 'test@example.com', phone_number: 'invalid_phone', otp_required_for_login: true, two_factor_auth_method: 'sms' } }

    it 'is invalid' do
      expect(form.validate(attr)).to be_falsey
    end
  end

  context 'when two_factor_auth_method is authenticator' do
    before { form.two_factor_auth_method = 'authenticator' }

    it 'authenticator_two_factor_auth_method? returns true' do
      expect(form.authenticator_two_factor_auth_method?).to be_truthy
    end
  end
end
