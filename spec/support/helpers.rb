module Support
  module Test
    module Helpers
      def create_todo
        Todo.create(
          title: "Defence",
          body: "4",
          status: "Pending",
          created_at: Time.now
        )
      end
    end
  end
end
