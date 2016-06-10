module Roh
  module Routing
    class Mapper
      def find(endpoints, request)
        http_verb = request.request_method.downcase.to_sym
        endpoints[http_verb].detect do |route_val|
          match_path_with_endpoint(route_val, request)
        end
      end

      private

      def match_path_with_endpoint route_val, request
        regex, placeholders = route_val[:pattern]
        if regex =~ request.path_info
          match_data = Regexp.last_match
          placeholders.each do |placeholder|
            request.update_param(placeholder, match_data[placeholder])
          end
          true
        end
      end
    end
  end
end
