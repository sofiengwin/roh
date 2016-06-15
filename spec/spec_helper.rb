require "simplecov"
SimpleCov.start

require "coveralls"
require "roh"
require "rspec"
require "rack/test"
require "support/helpers"

Coveralls.wear!

ENV["RACK_ENV"] = "test"
APP_ROOT ||= __dir__ + "/hyperloop"

require_relative "hyperloop/config/application.rb"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../../spec", __FILE__)

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.include Roh::Helpers
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end

RSpec.shared_context type: :feature do
  require "capybara/rspec"
  before(:all) do
    app = Rack::Builder.parse_file(
      "#{__dir__}/hyperloop/config.ru"
    ).first
    Capybara.app = app
  end
end
