module Roh
  class BaseModel < QueryHelpers
    attr_accessor :errors

    def initialize(attributes = {})
      @errors = {}
      attributes.each { |column_name, value| send("#{column_name}=", value) }
    end

    def self.find(id)
      row = @@db.execute(
        "SELECT #{all_columns} FROM #{@@table_name} WHERE id = ?", "#{id}"
      ).first
      map_row_to_object(row)
    end

    def self.all
      data = @@db.execute(
        "SELECT #{@@property.keys.join(', ')} FROM #{@@table_name}"
      )
      data.map do |row|
        map_row_to_object(row)
      end
    end

    def self.count
      data = @@db.execute("SELECT COUNT(*) FROM #{@@table_name}")
      data[0][0]
    end

    def self.last
      row = @@db.execute(
        "SELECT * FROM #{@@table_name} ORDER BY id DESC LIMIT 1"
      ).first
      map_row_to_object(row)
    end

    def self.first
      row = @@db.execute(
        "SELECT * FROM #{@@table_name} ORDER BY id LIMIT 1"
      ).first
      map_row_to_object(row)
    end

    def self.destroy_all
      @@db.execute("DELETE FROM #{@@table_name}")
    end

    def self.map_row_to_object(row)
      model = self.new
      @@property.keys.each_with_index do |attribute, index|
        model.send("#{attribute}=", row[index])
      end
      model
    end

    def save
      if id
        update_attributes
      else
        new_record
      end

      true

    rescue SQLite3::ConstraintException => error
      error_name = error.message.split(".").last
      key = error_name.to_sym
      send(:errors=, key: "#{error_name.capitalize} can't be blank")
    end

    def update_attributes
      @@db.execute(<<SQL, [title, body, status, created_at])
     UPDATE #{@@table_name}
     SET
     #{update_record_placeholders}
     WHERE
     id = ?
SQL
    end

    def new_record
      @@db.execute "INSERT INTO #{@@table_name} (#{get_columns}) VALUES (#{new_record_placeholders})", [title, body, status, created_at.to_s]
    end

    def update(attributes)
      attributes.each do |key, value|
        send("#{key}=", value)
      end
      save
    end

    def destroy
      @@db.execute "DELETE FROM #{@@table_name} WHERE id = ?", id
    end

    def method_missing(method, *args)
      if method.to_s.end_with?("=")
        send(:errors=, attribute: "#{method.to_s.chop} is invalid")
      else
        super
      end
    end
  end
end
