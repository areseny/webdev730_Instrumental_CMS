OmniAuth.config.logger = Rails.logger

# Redirect to failure also in development mode
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(:google_oauth2, ENV['YOUTUBE_KEY'], ENV['YOUTUBE_SECRET'], {
    scope: [
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/youtube",
      "https://www.googleapis.com/auth/youtube.upload"
    ].join(" "),
    prompt: 'consent',
    access_type: 'offline',
    name: :youtube
  })
  provider(:soundcloud, ENV['SOUNDCLOUD_KEY'], ENV['SOUNDCLOUD_SECRET'])
end
