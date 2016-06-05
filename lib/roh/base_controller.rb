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
      layout_template, view_template = prepare_view_template(view_name)
      title = view_name.capitalize
      view_object = assign
      layout_template.render(view_object, title: title) do
        view_template.render(view_object, locals)
      end
    end

    def prepare_view_template(view_name)
      layout_file =  file_name = File.join(APP_ROOT, "app", "views", "layout", "application.html.erb")
      layout_template = Tilt::ERBTemplate.new(layout_file)
      view_file =  file_name = File.join(APP_ROOT, "app", "views", controller_name, "#{view_name}.html.erb")
      view_template = Tilt::ERBTemplate.new(view_file)

      [layout_template, view_template]
    end


    def get_instance_vars
      vars = {}
      variables = instance_variables - [:@request]
      variables.each do |var|
        key = var.to_s.gsub("@", "").to_sym
        vars[key] = instance_variable_get(var)
      end
      vars
    end

    def assign
      Struct.new("ViewObject")
      obj = Struct::ViewObject.new
      get_instance_vars.each do |key, value|
        obj.instance_variable_set("@#{key}", value)
      end

      obj
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
