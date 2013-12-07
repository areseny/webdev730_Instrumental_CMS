require 'faraday'

class Recaptcha

  def self.check_response(challenge, response, ip_address)
    Faraday.post("http://www.google.com/recaptcha/api/verify",
      privatekey: ENV['RECAPTCHA_PRIVATE_KEY'],
      remoteip: ip_address,
      challenge: challenge,
      response: response).body =~ /\Atrue$/
  end

end
