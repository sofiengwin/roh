class ItemsController < ApplicationController
  def new
    @item = Item.new(todo_id: params["todo_id"])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to "/todo/#{@item.todo_id}/show"
    else
      render :new
    end
  end

  private

  def item_params
    {
      title: params["item"]["title"],
      body: params["item"]["body"],
      todo_id: params["todo_id"]
    }
  end
end
