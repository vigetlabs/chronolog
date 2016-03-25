if ENV['COV']
  require 'simplecov'

  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'chronolog'
require 'factory_girl_rails'
require 'shoulda/matchers'
require 'database_cleaner'
require 'generator_spec'
require 'pry'
require 'devise'

# Set up Devise before loading support models
Devise.setup do |config|
  require 'devise/orm/active_record'

  config.case_insensitive_keys              = [:email]
  config.strip_whitespace_keys              = [:email]
  config.skip_session_storage               = [:http_auth]
  config.stretches                          = Rails.env.test? ? 1 : 10
  config.expire_all_remember_me_on_sign_out = true
  config.password_length                    = 8..72
  config.sign_out_via                       = :delete
end

%w(
  /support/**/*.rb
  /factories/**/*.rb
).each do |file_set|
  Dir[File.dirname(__FILE__) + file_set].each { |file| require file }
end

Chronolog::Test::Database.build

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Stub rails application when necessary.
unless Rails.application.present?
  Rails.application = OpenStruct.new(
    config:      OpenStruct.new(eager_load: false),
    eager_load!: true
  )
end
