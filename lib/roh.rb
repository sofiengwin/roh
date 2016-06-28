require "pry"
require "roh/version"
require "roh/dependencies"
require "roh/utilities"
require "roh/routing/router"
require "roh/routing/mapper"
require "roh/request_handler"
require "roh/base_controller"
require "roh/orm/database"
require "roh/orm/validations"
require "roh/orm/associations"
require "roh/orm/query_helpers"
require "roh/orm/base_model"

module Roh
  class Application
    attr_accessor :routes

    def initialize
      @routes ||= Routing::Router.new
    end

    def call(env)
      hide_favicon(env)
      request = Rack::Request.new(env)
      route = mapper.find(routes.endpoints, request)
      if route
        handler = RequestHandler.new(request, route)
        handler.get_rack_app
      else
        [400, {}, ["Invalid route"]]
      end
    end

    private

    def mapper
      @mapper ||= Routing::Mapper.new
    end

    def hide_favicon(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {}, []]
      end
    end
  end
end
