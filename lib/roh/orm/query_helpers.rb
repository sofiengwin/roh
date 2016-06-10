require "sqlite3"

module Roh
  class QueryHelpers
    @@db ||= SQLite3::Database.new "app.db"


     def self.to_table(table_name)
       @table_name = table_name
     end

     def self.create_table
       @@db.execute "CREATE TABLE IF NOT EXISTS todo (#{get_all_properties(@property).join(', ')})"
     end

     def self.property(column_name, args)
       @property ||= {}
       @property[column_name] = args
       attr_accessor column_name
     end

     def self.get_all_properties(property)
       all_properties = []
       property.each do |column_name, contraints|
         properties ||= []
         properties << column_name.to_s
         contraints.each do |key, value|
           properties << send("#{key.downcase}_query", value)
         end
         all_properties << properties.join(" ")
       end
       all_properties
     end

     def self.nullable_query(value = true)
       "NOT NULL" unless value
     end

     def self.primary_key_query(value = false)
       "PRIMARY KEY AUTOINCREMENT" if value
     end

     def self.type_query(value)
       value.to_s
     end

     def self.all_columns
       sql = @@db.prepare " SELECT * FROM todo"
       binding.pry
       sql.columnns
     end
  end
end
