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
  # DatabaseCleaner manages its own transaction per example below (see
  # around(:each)); rspec-rails's own transactional wrapping defaults to on
  # and double-wraps every example in a second, separately-managed
  # transaction, which was observed to leave stray committed rows behind
  # for at least one example per run. Disable it so DatabaseCleaner is the
  # only thing managing per-example transactions.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # Warm the schema cache for every table before the first DatabaseCleaner
    # transaction opens. Without this, the *first* example to touch a given
    # table triggers SQLite schema introspection (PRAGMA table_info, via
    # ActiveRecord's lazy per-table column cache) while inside that
    # example's DatabaseCleaner transaction. That introspection query was
    # observed to silently end the open transaction, so the rows that
    # example creates commit for real instead of rolling back, leaking into
    # every subsequent example for the rest of the run.
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
