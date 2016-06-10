module Roh
 class BaseModel < QueryHelpers
   def initialize(attributes = {})
     attributes.each { |column_name, value| send("#{column_name}=", value) }
   end

   def self.find(id)
     row = @@db.execute( "SELECT id, title, body, status, created_at from todo WHERE id = ?", id).first
   end

   def save
     @@db.execute "INSERT INTO todo (title, body, status, created_at ) VALUES (?, ?, ?, ?)", [title, body, status, created_at.to_s]
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
 end
end
