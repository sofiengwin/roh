module Roh
  class BaseController
    attr_reader :request

    def initialize request
      @request = request
    end

    def params
      request.params
    end
    def get_response
      @response
    end

    def response(body, status=200, header={})
      @response = Rack::Response.new(body, status, header)
    end

    def render(*args)
      response(render_template(*args))
    end

    def render_template(view_name, locals = {})
      file_name = File.join(APP_ROOT, "app", "views", controller_name, "#{view_name}.erb")
      template = File.read(file_name)
      vars = {}

      instance_variables.each do |var|
        key = var.to_s.gsub("@", "").to_sym
        vars[key] = instance_variable_get(var)
      end
      template = Tilt::ERBTemplate.new('templates')
      template.render(vars)
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

    def dispatch(action)
      self.send(action)

      if get_response
        get_response
      else
        render(action)
        get_response
      end
    end

    def self.action(action_name, request)
      self.new(request).dispatch(action_name)
    end

  end
end
