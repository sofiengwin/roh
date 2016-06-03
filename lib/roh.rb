require "pry"
require "roh/version"
require "roh/dependencies"
require "roh/utilities"
require "roh/routing/router"
require "roh/request_handler"
require "roh/base_controller"

module Roh
  class Application
    attr_accessor :routes

    def initialize
      @routes ||= Routing::Router.new
    end

    def call(env)
      # hide_favicon
      # get_rack_app(env)
      request = Rack::Request.new(env)
      route = match_route(request)
      handler = RequestHandler.new(request, route)
      handler.get_rack_app
      # [200, {}, ["Hello world"]]
    end

    private

    def match_route(request)
      http_verb = request.request_method.downcase.to_sym
      route = @routes.endpoints[http_verb].detect do|route_val|
        route_val[:pattern].match(request.path_info)
      end

      route
    end

    def hide_favicon
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {}, []]
      end
    end

  end
end
