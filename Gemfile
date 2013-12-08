source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'rails-i18n', '4.0.0'
gem 'pg'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'unicorn'
gem 'redcarpet'
gem 'memcachier'
gem 'dalli'
gem 'faraday'
gem 'airbrake'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-soundcloud'
gem 'faraday_middleware'

# Assets precompilation
gem 'sass-rails', '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'unf'
gem 'asset_sync'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'foreman'
  gem 'quiet_assets'
  gem 'guard-bundler'
  gem 'guard-livereload'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'vcr'
  gem 'factory_girl'
  gem 'capybara'
end
