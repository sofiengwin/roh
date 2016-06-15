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
    redirect_to "/"
  end

  def edit
    @todo = Todo.find(params["id"])
  end

  def update
    todo = Todo.find(params["id"])
    todo.update(todo_params)
    redirect_to "/todo/#{todo.id}/show"
  end

  def destroy
    @todo = Todo.find(params["id"])
    @todo.destroy
    redirect_to "/todo/index"
  end

  private

  def todo_params
    params["todo"].symbolize_keys
  end
end
