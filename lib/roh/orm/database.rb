require "sqlite3"

module Roh
  class Database
    def self.connect
      @db ||= SQLite3::Database.new("app.db")
    end

    def self.execute_query(*query)
      connect.execute(*query)
    end
  end
end
