APP_ROOT = __dir__

require_relative "config/application.rb"

binding.pry
HyperloopApplication = Hyperloop::Application.new
require_relative "config/routes.rb"
run HyperloopApplication
