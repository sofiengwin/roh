require "sqlite3"
require_relative "base_model"

class Post < Roh::BaseModel; end
STDERR.puts Post.schema.inspect
