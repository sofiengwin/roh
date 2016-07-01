module Roh
  module Persistence
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def create(attributes)
        model = new(attributes)
        model.created_at = Time.now.to_s
        model.save
        id = Database.execute_query "SELECT last_insert_rowid()"
        model.id = id[0][0]
        model
      end
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
