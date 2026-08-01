# Every appraise block below declares its own `sqlite3` constraint. The
# root Gemfile intentionally leaves sqlite3 unpinned: activerecord 6.1/7.0
# hard-pin `gem "sqlite3", "~> 1.4"` internally
# (lib/active_record/connection_adapters/sqlite3_adapter.rb), while 8.0/8.1
# require `>= 2.1`. Bundler disallows declaring the same gem twice with
# different version requirements in one Gemfile, so each Rails version's
# compatible sqlite3 range has to live here instead of in the shared Gemfile.

appraise 'rails-6.1' do
  gem 'rails', '~> 6.1.0'

  # Ruby 3.4 demoted mutex_m from a default gem to a regular gem;
  # activesupport 6.1.x calls `require 'mutex_m'` internally without
  # declaring it as a dependency. Only rails-6.1 needs this pin.
  gem 'mutex_m'

  # Ruby 4.0 removed benchmark from the default gems the same way; activesupport
  # 6.1.x requires it internally (core_ext/benchmark.rb) without declaring it.
  gem 'benchmark'

  gem 'sqlite3', '~> 1.4'
end

appraise 'rails-7.0' do
  gem 'rails', '~> 7.0.0'
  gem 'sqlite3', '~> 1.4'
end

appraise 'rails-7.1' do
  gem 'rails', '~> 7.1.0'
  gem 'sqlite3', '~> 2.9'
end

appraise 'rails-7.2' do
  gem 'rails', '~> 7.2.0'
  gem 'sqlite3', '~> 2.9'
end

appraise 'rails-8.0' do
  gem 'rails', '~> 8.0.0'
  gem 'sqlite3', '~> 2.9'
end

appraise 'rails-8.1' do
  gem 'rails', '~> 8.1.0'
  gem 'sqlite3', '~> 2.9'
end
