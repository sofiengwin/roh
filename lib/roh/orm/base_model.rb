module Roh
 class BaseModel < QueryHelpers
   def initialize(attributes = {})
     attributes.each { |column_name, value| send("#{column_name}=", value) }
   end

   def self.find(id)
     row = @@db.execute("SELECT id, title, body, status, created_at FROM todo WHERE id = ?", id).first
     binding.pry
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
       update
     else
       @@db.execute "INSERT INTO todo (title, body, status, created_at ) VALUES (?, ?, ?, ?)", [title, body, status, created_at.to_s]
     end
   end

   def update
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


 end
end
