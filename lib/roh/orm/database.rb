require "sqlite3"

module Roh
  class Database
    def self.connect
      SQLite3::Database.new("app.db")
    end
  end
end
