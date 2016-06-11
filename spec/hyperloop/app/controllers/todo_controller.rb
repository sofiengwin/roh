class TodoController < ApplicationController
  def index
    @todos = Todo.all
  end

  def new
    @todo = Todo.new
  end

  def show
    @todo = Todo.find(params["id"])
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.save
  end

  def edit
    @todo = Todo.find(1)
  end

  def update
    @todo = Todo.find(1)
    @todo.update(todo_params)
  end

  def destroy
    @todo = Todo.find(1)
    @todo.destroy
  end

  private

  def todo_params
    params["todo"].symbolize_keys
  end
end
