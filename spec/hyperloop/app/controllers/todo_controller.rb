class TodoController < ApplicationController
  def index
    @name = "James"
    @todo = Todo.new(title: "Second Post", body: "On the way", status: "done", created_at: Time.now)
    # @todo.title = "First ToDo"
    # @todo.body = "This is going great"
    # @todo.status = "completed"
    # @todo.created_at = Time.now
    binding.pry
    @todo.save
  end

  def new
    @todo = Todo.new
  end

  def create
    binding.pry
    @todo = Todo.new
  end
end
