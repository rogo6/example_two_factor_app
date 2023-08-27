class User < ApplicationRecord
  devise :two_factor_authenticatable, :registerable, :recoverable, :validatable, :lockable

  enum two_factor_auth_method: { sms: 0, email: 1, authenticator: 2 }, _suffix: true
end
