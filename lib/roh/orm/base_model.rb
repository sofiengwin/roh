module Roh
  class BaseModel
    include QueryHelpers
    include Validations
    include Persistence
    extend Associations

    attr_accessor :errors

    def initialize(attributes = {})
      @errors = {}
      send(:created_at=, Time.now.to_s)
      attributes.each { |column_name, value| send("#{column_name}=", value) }
    end

    def self.find(id)
      row = Database.execute_query(
        "SELECT * FROM #{table_name} WHERE id = ?", "#{id}"
      ).first
      map_row_to_object(row)
    end

    def self.find_by(params)
      row = Database.execute_query(
        "SELECT * FROM #{table_name} WHERE #{params.keys[0]}=?  LIMIT 1",
        "#{params.values[0]}"
      )
      map_row_to_object(row[0])
    end

    def self.all
      rows = Database.execute_query(
        "SELECT * FROM #{table_name}"
      )
      rows.map do |row|
        map_row_to_object(row)
      end
    end

    def self.count
      data = Database.execute_query("SELECT COUNT(*) FROM #{table_name}")
      data[0][0]
    end

    def self.last
      row = Database.execute_query(
        "SELECT * FROM #{table_name} ORDER BY id DESC LIMIT 1"
      ).first
      map_row_to_object(row)
    end

    def self.first
      row = Database.execute_query(
        "SELECT * FROM #{table_name} ORDER BY id LIMIT 1"
      ).first
      map_row_to_object(row)
    end

    def self.destroy_all
      Database.execute_query("DELETE FROM #{table_name}")
    end

    def self.where(query_pattern, value)
      rows = Database.execute_query "SELECT * FROM
        #{table_name} WHERE #{query_pattern}", value

      rows.map do |row|
        map_row_to_object(row)
      end
    end

    def self.map_row_to_object(row)
      return nil unless row
      model = self.new
      properties.keys.each_with_index do |attribute, index|
        model.send("#{attribute}=", row[index])
      end
      model
    end
  end
end
