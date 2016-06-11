APP_ROOT = __dir__

use Rack::MethodOverride
require_relative "config/application.rb"
HyperloopApplication = Hyperloop::Application.new
require_relative "config/routes.rb"
run HyperloopApplication
