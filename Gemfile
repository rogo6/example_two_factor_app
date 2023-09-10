source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

gem "rails", "~> 7.0.6"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

gem 'simple_form'
gem 'reform-rails'
gem 'haml'

gem 'devise'
gem 'devise-two-factor'
gem 'dotenv-rails'
gem 'rqrcode'
gem 'twilio-ruby'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'letter_opener'
  gem 'letter_opener_web'
end

group :development do
  gem "web-console"
end

group :test do
  gem 'vcr'
  gem 'database_cleaner', require: false
  gem "webdrivers"
  gem 'rspec-rails'
  gem 'webmock', require: false
end
