require "spec_helper"

RSpec.describe Roh::BaseModel do
  describe "#save" do
    after(:all) do
      Todo.destroy_all
    end

    context "when creating todo with valid details" do
      it "returns newly created todo" do
        todo = Todo.new attributes_for(:todo)
        todo.save
        expect(Todo.last.title).to eq todo.title
        Todo.destroy_all
      end

      it "increases the count of todos" do
        todo = Todo.new attributes_for(:todo)
        expect do
          todo.save
        end.to change(Todo, :count).by 1
        Todo.destroy_all
      end
    end

    context "when creating todo with invalid details" do
      it "returns error messages" do
        todo = Todo.new attributes_for(:todo, title: "", body: nil)
        todo.save
        expect(todo.errors[:title]).to include "Title can't be blank"
        expect(todo.errors[:body]).to include "Body can't be blank"
        Todo.destroy_all
      end
    end
  end

  describe "#update" do
    before(:all) do
      @todo = create(:todo)
    end

    after(:all) do
      Todo.destroy_all
    end

    context "when updating with valid data" do
      it "doesn't create a new record in the database" do
        expect do
          @todo.update(body: "Watch the machester derby")
        end.to change(Todo, :count).by 0
      end

      it "updates the object" do
        @todo.update(title: "Watch el classico")
        expect(Todo.find(@todo.id).title).to eq "Buy a chevrolet camaro"
      end
    end
  end

  describe "#destroy" do
    it "decrease the count of todos" do
      todo = create(:todo)
      expect do
        todo.destroy
      end.to change(Todo, :count). by(-1)
    end
    Todo.destroy_all
  end

  describe ".all" do
    context "when database is not empty" do
      before(:all) do
        create(:todo, title: "Checkpoint Defence zero")
        create(:todo, title: "Checkpoint Defence one")
        create(:todo, title: "Checkpoint Defence two")
      end

      it "returns all todos in the database" do
        todos = Todo.all
        expect(todos[0].title).to eq "Checkpoint Defence zero"
        expect(todos[1].title).to eq "Checkpoint Defence one"
        expect(todos[2].title).to eq "Checkpoint Defence two"
        Todo.destroy_all
      end
    end

    context "when database is empty" do
      it "returns an empty array" do
        todos = Todo.all
        expect(todos).to eq []
      end
    end
  end

  describe ".last" do
    context "when there are records in the database" do
      it "returns the last created todo" do
        todo = create(:todo)
        expect(Todo.last.title).to eq todo.title
        Todo.destroy_all
      end
    end

    context "when database is empty" do
      it "returns nil" do
        expect(Todo.last).to eq nil
      end
    end
  end

  describe ".first" do
    context "when there are record on the database" do
      it "return the first todo in the database" do
        todos = create_list(:todo, 3)
        expect(Todo.first.title).to eq todos[0].title
        Todo.destroy_all
      end
    end

    context "when the database is empty" do
      it "returns nil" do
        expect(Todo.first).to eq nil
      end
    end
  end

  describe ".where" do
    it "returns matching records" do
      pending_todo = create(:todo, title: "completed todo", status: "Pending")
      completed_todo = create(:todo, status: "Completed")
      expect(Todo.where("status like ?", "%Pending%").first.status).to eq(
        pending_todo.status
      )

      expect(Todo.where("status like ?", "%Completed%").first.status).to eq(
        completed_todo.status
      )
      Todo.destroy_all
    end
  end

  describe ".create" do
    it "returns newly created record" do
      expect(Todo.create(attributes_for(:todo)).title).to eq(
        Todo.last.title
      )
      Todo.destroy_all
    end

    it "increase todos count" do
      expect do
        Todo.create(attributes_for(:todo))
      end.to change(Todo, :count).by 1
      Todo.destroy_all
    end
  end

  describe "model validations" do
    context "when length is too short" do
      it "returns 'lenght is too short' error message" do
        todo = create(:todo, title: "shot")
        expect(todo.errors[:title]).to include "Title is too short"
        Todo.destroy_all
      end
    end

    context "when length is too long" do
      it "returns 'lenght is too long' error message" do
        todo = create(
          :todo,
          title: "This is a vey lont title that will trigger validation error"
        )
        expect(todo.errors[:title]).to include "Title is too long"
        Todo.destroy_all
      end
    end

    context "when record does not match validation format" do
      it "returns 'pattern do not match' error message" do
        todo = create(:todo, title: "1234")
        expect(todo.errors[:title]).to include "Title didn't match pattern"
        Todo.destroy_all
      end
    end

    context "when title already exists" do
      it "returns 'already exists' error message" do
        create(:todo, title: "already exists")
        todo = Todo.new(attributes_for(:todo, title: "already exists"))
        todo.save
        expect(todo.errors[:title]).to include "Title already exist"
        Todo.destroy_all
      end
    end
  end

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
