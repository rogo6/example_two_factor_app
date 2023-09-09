class DeviseMailer < Devise::Mailer
  def send_two_factor_code(user)
    @user = user
    mail to: @user.email, subject: 'Two factor auth code'
  end
end
