class User < ApplicationRecord
  devise :two_factor_authenticatable, :registerable, :recoverable, :validatable, :lockable
end
