class ContactForm
  # TODO: specs & feature
  include ActiveModel::Model

  attr_accessor :name, :email, :message, :ip_address
  attr_accessor :captcha_challenge
  attr_accessor :captcha

  validates :name, presence: true
  validates :email, presence: true, email_format: { allow_blank: true }
  validates :message, presence: true
  validates :captcha, presence: true
  validate :matches_captcha

  private

  def matches_captcha
    if captcha.present? && !check_recaptcha
      errors.add(:captcha, :invalid_captcha)
    end
  end

  def private_key
    Rails.config.recaptcha_private_key
  end

  def check_recaptcha
    Recaptcha.check_response(captcha_challenge, captcha, ip_address)
  end

end
