class AddTwoFactorAuthenticationMethodToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :two_factor_auth_method, :integer, default: 0
  end
end
