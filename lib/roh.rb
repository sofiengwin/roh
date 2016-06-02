require "pry"
require "roh/version"
require "roh/routing/router.rb"

module Roh
  class Application
    attr_accessor :routes

    def initialize
      @routes ||= Routing::Router.new
    end

    def call(env)
      # hide_favicon
      # get_rack_app(env)
      [ 200, {}, ["Hello world"]]
    end

    private

    def hide_favicon
      if env["PATH_INFO"] == "/favicon.ico"
        return [404, {}, []]
      end
    end
  end
end
