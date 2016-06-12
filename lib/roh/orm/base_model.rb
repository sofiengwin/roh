module Roh
 class BaseModel < QueryHelpers
   attr_accessor :errors

   def initialize(attributes = {})
     @errors = {}
     attributes.each { |column_name, value| send("#{column_name}=", value) }
   end

   def self.find(id)
     row = @@db.execute("SELECT id, title, body, status, created_at FROM todo WHERE id = ?", "#{id}").first
     map_row_to_object(row)
   end

   def self.all
      data = @@db.execute "SELECT #{@property.keys.join(", ")} FROM todo"
      data.map do |row|
        map_row_to_object(row)
      end
   end

   def self.map_row_to_object(row)
     model = Todo.new
     @property.keys.each_with_index do |attribute, index|
       model.send("#{attribute}=", row[index])
     end
     model
   end

   def save
     if id
       update_attributes
     else
       @@db.execute "INSERT INTO todo (title, body, status, created_at ) VALUES (?, ?, ?, ?)", [title, body, status, created_at.to_s]
     end

      true

   rescue SQLite3::ConstraintException => error
     error_name = error.message.split(".").last
     key = error_name.to_sym
     send(:errors=, key: "#{error_name.capitalize} can't be blank")
   end

   def update_attributes
     @@db.execute(<<SQL, [title, body, status, created_at])
     UPDATE todo
     SET
     title = ?, body = ?, status = ?, created_at = ?
     WHERE
     id = ?
SQL
   end


   def update(attributes)
     attributes.each do |key, value|
       send("#{key}=", value)
     end
     save
   end

   def destroy
     @@db.execute "DELETE FROM todo WHERE id = ?", id
   end

   def method_missing(method, args)
     if method.to_s.end_with?("=")
       send(:errors=, attribute: "#{method.to_s.chop} is invalid")
     else
       super
     end
   end
 end
end
