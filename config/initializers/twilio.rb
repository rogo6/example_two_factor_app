if Rails.env.test?
  Twilio.configure do |config|
    config.account_sid = 'TWILIO_ACCOUNT_SID'
    config.auth_token = 'TWILIO_AUTH_TOKEN'
  end
else
  Twilio.configure do |config|
    config.account_sid = ENV['TWILIO_ACCOUNT_SID']
    config.auth_token = ENV['TWILIO_AUTH_TOKEN']
  end
end