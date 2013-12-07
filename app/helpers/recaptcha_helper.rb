module RecaptchaHelper

  def recaptcha_meta_tags
    meta_tags({
      "recaptcha-public-key" => ENV['RECAPTCHA_PUBLIC_KEY'],
      "recaptcha_language" => I18n.locale
    })
  end

  def recaptcha_box
    content_tag(:div, nil, id: 'recaptcha-box')
  end

end
