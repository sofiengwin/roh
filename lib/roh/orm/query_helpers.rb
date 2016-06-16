module Roh
  class QueryHelpers
    @@db ||= Roh::Database.connect
    @@table_name = ""
    @@property ||= {}

    def self.to_table(table_name)
      @@table_name = table_name
    end

    def self.create_table
      @@db.execute "CREATE TABLE IF NOT EXISTS #{@@table_name}
        (#{get_all_properties.join(', ')})"
    end

    def self.property(column_name, args)
      @@property[column_name] = args
      attr_accessor column_name
    end

    def self.get_all_properties
      all_properties = []
      @@property.each do |column_name, contraints|
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
      columns = @@property.keys
      columns.join(", ")
    end

    def get_columns
      columns = @@property.keys
      columns.delete(:id)
      columns.join(", ")
    end

    def new_record_placeholders
      (["?"] * (@@property.size - 1)).join(", ")
    end

    def new_record_values
      columns = @@property.keys
      columns.delete(:id)
      columns.map { |column| send(column) }
    end

    def update_record_values
      new_record_values << send(:id)
    end

    def update_record_placeholders
      columns = @@property.keys
      columns.delete(:id)
      columns.map { |column| "#{column} = ?" }.join(", ")
    end
  end
end
