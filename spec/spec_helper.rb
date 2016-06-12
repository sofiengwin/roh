require "rspec"
require "rack/test"
require "support/helpers"

ENV["RACK_ENV"] = "test"
APP_ROOT ||= __dir__ + "/hyperloop"

require_relative "hyperloop/config/application.rb"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../spec", __FILE__)

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Support::Test::Helpers
end

require "roh"
