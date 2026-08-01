ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start do
  minimum_coverage 100
end

require File.expand_path('../../spec/dummy/config/environment.rb', __FILE__)
require 'rspec/rails'
require 'wor/paginate/rspec'
Dir[File.join('.', 'spec', 'support', '**', '*.rb')].each{ |f| require(f) }

ActiveRecord::Migrator.migrations_paths = [File.expand_path('../../spec/dummy/db/migrate', __FILE__)]
RSpec.configure do |config|
  # DatabaseCleaner already wraps each example in a transaction below;
  # rspec-rails's own wrapping double-nests it and was observed to leak
  # committed rows. Disable it here.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # Warms the schema cache before any DatabaseCleaner transaction opens.
    # Otherwise the first example touching a table triggers a PRAGMA
    # table_info query mid-transaction, which silently ends it and commits
    # that example's rows for real instead of rolling back.
    conn = ActiveRecord::Base.connection
    conn.data_sources.each { |t| conn.schema_cache.add(t) }
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Response::JSONParser, type: :controller
  config.include Response::JSONParser, type: :request
end

require 'byebug'
