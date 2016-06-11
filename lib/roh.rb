require "pry"
require "roh/version"
require "roh/dependencies"
require "roh/utilities"
require "roh/routing/router"
require "roh/routing/mapper"
require "roh/request_handler"
require "roh/base_controller"
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
      route = match_route(routes, request)
      handler = RequestHandler.new(request, route)
      handler.get_rack_app
    end

    private

    def match_route(routes, request)
      endpoints = routes.endpoints
      @mapper = Routing::Mapper.new.find(endpoints, request)
    end

    def hide_favicon(env)
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {}, []]
      end
    end

  end
end
