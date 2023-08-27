module Users
  class UpdateForm < Reform::Form
    model User

    property :email
    property :phone_number
    property :two_factor_auth_method

    validates :email, presence: true
    validates :two_factor_auth_method, inclusion: { in: User.two_factor_auth_methods.keys }
    validate :valid_phone

    def save_form(attr = {})
      return unless validate(attr)

      save
    end

    private

    def sms_auth_method?
      two_factor_auth_method == 'sms'
    end

    def valid_phone
      return unless sms_auth_method?
      return if phone_number&.match(/^\+[1-9]\d{1,14}$/)

      errors.add(:phone_number, :invalid)
    end
  end
end