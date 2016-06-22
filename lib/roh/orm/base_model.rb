module Roh
  class BaseModel < QueryHelpers
    attr_accessor :errors
    @@validator = {}

    def initialize(attributes = {})
      @errors = {}
      send(:created_at=, Time.now.to_s)
      attributes.each { |column_name, value| send("#{column_name}=", value) }
    end

    def self.find(id)
      row = @@db.execute(
        "SELECT #{all_columns} FROM #{@@table_name} WHERE id = ?", "#{id}"
      ).first
      map_row_to_object(row)
    end

    def self.all
      rows = @@db.execute(
        "SELECT #{@@property.keys.join(', ')} FROM #{@@table_name}"
      )
      rows.map do |row|
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

    def self.create(attributes)
      object = new(attributes)
      object.created_at = Time.now.to_s
      object.save
      id = @@db.execute "SELECT last_insert_rowid()"
      object.id = id[0][0]
      object
    end

    def self.where(query_pattern, value)
      rows = @@db.execute "SELECT #{@@property.keys.join(',')} FROM
        #{@@table_name} WHERE #{query_pattern}", value

      rows.map do |row|
        map_row_to_object(row)
      end
    end

    def self.map_row_to_object(row)
      return nil unless row
      model = self.new
      @@property.keys.each_with_index do |attribute, index|
        model.send("#{attribute}=", row[index])
      end
      model
    end

    def self.validates(attribute, options)
      @@validator[attribute] = options
    end

    def valid_errors
      Validations.new(@@validator, self).record_errors
    end

    def save
      if valid_errors.empty?
        if id
          update_attributess
        else
          new_record
        end
        true
      else
        errors.update(valid_errors)
        false
      end
    end

    alias save! save

    def update_attributes
      query = "UPDATE #{@@table_name} SET #{update_record_placeholders} WHERE
        id = ?"
      @@db.execute(query, update_record_values)
    end

    def new_record
      @@db.execute "INSERT INTO #{@@table_name} (#{get_columns}) VALUES
        (#{new_record_placeholders})", new_record_values
      id = @@db.execute "SELECT last_insert_rowid()"
      self.id = id[0][0]
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
