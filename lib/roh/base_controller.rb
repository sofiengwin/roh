module Roh
  class BaseController
    def self.action(action_name)
      self.new(env).dispatch(action_name)
    end
  end
end
