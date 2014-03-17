require 'coveralls'
Coveralls.wear!

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require "#{::Rails.root}/app/helpers/application_helper"
require 'database_cleaner'
require 'factory_girl_rails'
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  DatabaseCleaner.strategy = :truncation

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.order = 'random'

  config.include ApplicationHelper, type: :helper
  config.include Devise::TestHelpers, type: :controller
  config.before(:each) do
    PaperTrail.enabled = false
  end

  config.before(:each, versioning: true) do
    PaperTrail.enabled = true
  end
end
