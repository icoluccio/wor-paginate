source 'https://rubygems.org'

# Declare your gem's dependencies in wor-paginate.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :development, :test do
  gem 'active_model_serializers', '~> 0.10.16'
  gem 'appraisal', '~> 2.5'
  gem 'byebug', '~> 13.0'
  gem 'database_cleaner-active_record', '~> 2.2', require: 'database_cleaner/active_record'
  gem 'factory_bot_rails', '~> 6.5'
  gem 'faker', '~> 3.8'
  gem 'generator_spec', '~> 0.10'
  gem 'kaminari', '~> 1.2'
  gem 'overcommit', '~> 0.71'
  gem 'panko_serializer', '~> 0.8.5'
  gem 'puma', '~> 6.0'
  gem 'rake', '~> 13.0'
  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '>= 6.0', '< 9'
  gem 'rubocop', '~> 1.88'
  gem 'rubocop-rspec', '~> 3.10'
  gem 'simplecov', '~> 0.22'
  # sqlite3 is intentionally NOT pinned here: activerecord 6.1/7.0 hard-pin
  # `gem "sqlite3", "~> 1.4"` internally (sqlite3_adapter.rb) while 8.0/8.1
  # require `>= 2.1`. Bundler disallows declaring the same gem twice with
  # different version requirements, so each appraise block in `Appraisals`
  # declares the sqlite3 constraint that matches its Rails version instead.
  gem 'webmock', '~> 3.26'
  gem 'will_paginate', '~> 4.0'
end
