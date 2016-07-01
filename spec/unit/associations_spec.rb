require "spec_helper"

RSpec.describe "Associations" do
  describe "associations" do
    context "has_many associations" do
      it "returns all records belonging to the current object" do
        todo = create(:todo, title: "belongs to associations")
        item = create(:item, title: "associations", todo_id: todo.id)
        expect(todo.items[0].title).to eq item.title
        Todo.destroy_all
        Item.destroy_all
      end
    end

    context "belongs_to associations" do
      it "returns parent object of the current object" do
        todo = create(:todo, title: "has many associations")
        item = create(:item, todo_id: todo.id)
        expect(item.todo.title).to eq todo.title
        Todo.destroy_all
        Item.destroy_all
      end
    end
  end
end
