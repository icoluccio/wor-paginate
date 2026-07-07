# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __dir__)

# Ruby 3.4+ no longer auto-requires the 'logger' default gem, but
# ActiveSupport (Rails 6.1's version in particular) expects the top-level
# Logger constant to already be defined when it boots. Require it explicitly
# before Bundler/Rails load to avoid:
#   NameError: uninitialized constant ActiveSupport::LoggerThreadSafeLevel::Logger
require 'logger'

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)
