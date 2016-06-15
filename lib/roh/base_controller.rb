require "active_support/core_ext/hash/indifferent_access"

module Roh
  class BaseController
    attr_accessor :request

    def initialize(request)
      @request = request
    end

    def params
      request.params
    end

    def get_response
      @response
    end

    def redirect_to(address, status: 301)
      response([], status, "Location" => address)
    end

    def response(body, status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def render(*args)
      response(render_template(*args))
    end

    def render_template(view_name, locals = {})
      layout_template, view_template = prepare_view_template(view_name)
      title = view_name.capitalize
      layout_template.render(self, title: title) do
        view_template.render(self, locals)
      end
    end

    def prepare_view_template(view_name)
      layout_file = File.join(APP_ROOT, "app", "views", "layout", "application.html.erb")
      layout_template = Tilt::ERBTemplate.new(layout_file)
      view_file = File.join(APP_ROOT, "app", "views", controller_name, "#{view_name}.html.erb")
      view_template = Tilt::ERBTemplate.new(view_file)

      [layout_template, view_template]
    end

    def get_instance_vars
      vars = {}
      variables = instance_variables - [:@request]
      variables.each do |var|
        key = var.to_s.delete("@").to_sym
        vars[key] = instance_variable_get(var)
      end
      vars
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

    def dispatch(action)
      send(action)
      render(action) unless get_response
      get_response

      # if get_response
      #   binding.pry
      #   get_response
      # else
      #   binding.pry
      #   render(action)
      #   get_response
      # end
    end

    def self.action(action_name, request)
      self.new(request).dispatch(action_name)
    end
  end
end
