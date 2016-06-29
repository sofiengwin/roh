module Roh
  module QueryHelpers
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def to_table(table_name)
        @table_name ||= table_name
      end

      def table_name
        @table_name
      end

      def create_table
        Roh::Database.execute_query "CREATE TABLE IF NOT EXISTS #{@table_name}
        (#{get_all_properties.join(', ')})"
      end

      def property(column_name, args)
        @properties ||= {}
        @properties[column_name] = args
        attr_accessor column_name
      end

      def properties
        @properties
      end

      def get_all_properties
        all_properties = []
        @properties.each do |column_name, contraints|
          properties ||= []
          properties << column_name.to_s
          contraints.each do |key, value|
            properties << send("#{key.downcase}_query", value)
          end
          all_properties << properties.join(" ")
        end
        all_properties
      end

      def nullable_query(value = true)
        "NOT NULL" unless value
      end

      def primary_key_query(value = false)
        "PRIMARY KEY AUTOINCREMENT" if value
      end

      def type_query(value)
        value.to_s
      end
    end

    def table_name
      self.class.table_name
    end

    def properties
      self.class.properties
    end

    def get_columns
      columns = properties.keys
      columns.delete(:id)
      columns.join(", ")
    end

    def new_record_placeholders
      (["?"] * (properties.size - 1)).join(", ")
    end

    def new_record_values
      columns = properties.keys
      columns.delete(:id)
      columns.map { |column| send(column) }
    end

    def update_record_values
      new_record_values << send(:id)
    end

    def update_record_placeholders
      columns = properties.keys
      columns.delete(:id)
      columns.map { |column| "#{column} = ?" }.join(", ")
    end
  end
end
