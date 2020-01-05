# frozen_string_literal: true

require "active_record"
require "database_cleaner"
require "factory_bot"
require "rspec-rails"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Delete everything from the database before the suite runs.
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  # Before each test run, run everything as a transaction and then rollback.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Before each JS test, run deletion.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
