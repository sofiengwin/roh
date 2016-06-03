module Roh
  module Routing
    class Router
      attr_accessor :endpoints

      def endpoints
        @endpoints ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def draw(&block)
        instance_eval(&block)
      end

      [:get, :post, :put, :patch, :delete].each do |method_name|
        define_method(method_name) do |url, *options|
          route_data = {
            path: url,
            pattern: regexp_pattern(url),
            controller_and_action: controller_and_action(options)
          }
          endpoints[method_name] << route_data
        end
      end

      def regexp_pattern(url_elements)
        # TODO: Refactor this
        url_elements = url_elements.split("/")
        placeholder = []

        url_elements.each do |element|
          if element.start_with?(":")
            placeholder << "(?<id>\\d+)"
          else
            placeholder << element
          end
        end

        Regexp.new(placeholder.join("/"))
      end

      def controller_and_action(options)
        controller_and_action = options.shift[:to].split("#")
        controller_name, action = controller_and_action
        controller = controller_name.to_camel_case + "Controller"
        [controller, action]
      end

    end
  end
end
