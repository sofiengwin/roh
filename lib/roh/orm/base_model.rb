module Roh
  class BaseModel
    include QueryHelpers
    include Validations
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

    def self.find_by(key_value)
      row = Database.execute_query(
        "SELECT * FROM #{table_name} WHERE #{key_value.keys[0]}=?  LIMIT 1",
        "#{key_value.values[0]}"
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

    def self.create(attributes)
      model = new(attributes)
      model.created_at = Time.now.to_s
      model.save
      id = Database.execute_query "SELECT last_insert_rowid()"
      model.id = id[0][0]
      model
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

    def save
      validate
      if errors.empty?
        if id
          update_attributes
        else
          new_record
        end
        true
      else
        false
      end
    end

    alias save! save

    def update_attributes
      query = "UPDATE #{table_name} SET #{update_record_placeholders} WHERE
        id = ?"
      Database.execute_query(query, update_record_values)
    end

    def new_record
      Database.execute_query "INSERT INTO #{table_name} (#{get_columns}) VALUES
        (#{new_record_placeholders})", new_record_values
      id = Roh::Database.execute_query "SELECT last_insert_rowid()"
      self.id = id[0][0]
    end

    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
      save
    end

    def destroy
      Database.execute_query "DELETE FROM #{table_name} WHERE id = ?", id
    end
  end
end
