require 'vcr'

VCR.configure do |config|
  config.hook_into :faraday
  config.cassette_library_dir = File.expand_path("../../fixtures/cassettes", __FILE__)
  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: [:uri, :method, :body]
  }
  config.configure_rspec_metadata!
end
