require 'api/recaptcha'
require 'support/vcr'

describe Recaptcha, vcr: true do
  let(:fixtures_path) { File.expand_path("../../../fixtures/recaptcha", __FILE__) }
  let(:public_key)    { ENV['RECAPTCHA_PUBLIC_KEY'] }
  let(:private_key)   { ENV['RECAPTCHA_PRIVATE_KEY'] }
  let(:ip_address)    { "127.0.0.1" }

  before do
    require 'dotenv'
    Dotenv.load
    VCR.configure do |c|
      c.filter_sensitive_data('<PRIVATE_KEY>') { private_key }
      c.filter_sensitive_data('<PUBLIC_KEY>')  { public_key }
    end
  end

  # The challenge code from the recaptcha server
  #
  let(:challenge) do
    url = "http://www.google.com/recaptcha/api/noscript"
    resp = Faraday.get("#{url}?k=#{public_key}").body
    /"recaptcha_challenge_field"\svalue="(.+)"/.match(resp)[1]
  end

  # The md5 hash of the challenge code (for smaller filenames)
  #
  let(:challenge_md5) do
    require 'digest/md5'
    Digest::MD5.hexdigest(challenge)
  end

  # Path to the downloaded image file.
  #
  let(:image_temp_file) do
    # When the cassette is not yet recorded, this file will be
    # downloaded and saved in /tmp
    url = "http://www.google.com/recaptcha/api/image?c=#{challenge}"
    filename = "/tmp/#{challenge_md5}.jpg"
    File.open(filename, "wb") { |f| f.write(Faraday.get(url).body) }
    filename
  end

  # The correct response for the challenge.
  #
  let(:correct_response) do
    filename = Dir["#{fixtures_path}/#{challenge_md5}-*.jpg"].first
    if filename
      # When the cassete is already recorded, returns the correct answer from
      # the name of the file saved in the fixtures path.
      /#{challenge_md5}-(.*)\.jpg$/.match(filename)[1].split("-").join(" ")
    else
      # When the cassette is not yet recorded, the image will be
      # automatically shown (works in Mac OS) and the correct answer
      # will be read from STDIN. The person running the spec must visualize
      # the image and input the correct answer.
      require 'launchy'
      require 'fileutils'
      Launchy.open(image_temp_file)
      puts "\nPlease type the two words you see on the image:"
      user_response = STDIN.gets.chomp
      resp = user_response.gsub(" ", "-")
      target_file = "#{fixtures_path}/#{challenge_md5}-#{resp}.jpg"
      FileUtils.cp image_temp_file, target_file
      user_response
    end
  end

  it "returns true if the response is correct" do
    result = Recaptcha.check_response(challenge, correct_response, ip_address)
    result.should be_true
  end

  it "returns false if the response is incorrect" do
    # spec will fail if it is actually foo bar (:trollface)
    result = Recaptcha.check_response(challenge, "foo bar", ip_address)
    result.should be_false
  end

end
