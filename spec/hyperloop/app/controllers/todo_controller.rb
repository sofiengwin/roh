class TodoController < ApplicationController
  def index

    @name = "James"
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.save
  end

  def edit
    @todo = Todo.find(params["id"])
  end

  def update
    @todo = Todo.find(params["id"])
  end

  def todo_params
    params["todo"].symbolize_keys
  end
end
