module ApplicationHelper
  def auth_code_info_message(send_method)
    case send_method.to_sym
    when :email
      'Code has been sent to your e-mail address. It will be valid for the next 2 minutes.'
    when :sms
      'Code has been sent to your mobile phone. It will be valid for the next 2 minutes.'
    else
      'Provide code from your authenticator app'
    end
  end

  def qr_code_as_svg(uri)
    RQRCode::QRCode.new(uri).as_svg(
      offset: 0,
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      standalone: true
    ).html_safe
  end
end
