APP_ROOT = __dir__

use Rack::MethodOverride
require_relative "config/application.rb"
HyperloopApplication = Hyperloop::Application.new
require_relative "config/routes.rb"

use Rack::Static, urls: ["/images", "/js", "/css"], root: "app/assets"

run HyperloopApplication
