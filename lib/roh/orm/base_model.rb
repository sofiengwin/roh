module Roh
 class BaseModel < QueryHelpers
   def initialize(attributes = {})
     attributes.each { |column_name, value| send("#{column_name}=", value) }
   end


   def save
     @@db.execute "INSERT INTO todo (title, body, status, created_at ) VALUES (?, ?, ?, ?)", [title, body, status, created_at.to_s]
   end
 end
end
