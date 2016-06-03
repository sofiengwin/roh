module Roh
  class RequestHandler
    attr_accessor :request, :route

    def initialize(request, route)
      @request = request
      @route = route
    end

    def get_rack_app
      controller_name, action = route[:controller_and_action]
      controller = Object.const_get(controller_name)
      controller.action(action, request)
    end

    def route_error

    end


  end
end
