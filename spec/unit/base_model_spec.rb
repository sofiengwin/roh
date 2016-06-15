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
      end

      it "increases the count of todos" do
        todo = Todo.new attributes_for(:todo)
        expect do
          todo.save
        end.to change(Todo, :count).by 1
      end
    end

    context "when creating todo with invalid data" do
      it "returns error message" do
        todo = create(:todo, title: nil)
        expect(todo.errors[:key]).to include "Title can't be blank"
      end

      it "doesn't increase count of todos" do
        expect do
          create(:todo, title: nil)
        end.to change(Todo, :count).by 0
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

    context "Updating with valid data" do
      it "doesn't create a new record in the database" do
        expect do
          @todo.update(body: "45")
        end.to change(Todo, :count).by 0
      end

      it "updates the object" do
        @todo.update(title: "barbosa")
        expect(Todo.find(@todo.id).title).to eq "barbosa"
      end
    end

    context "when updating with invalid details" do
      it "returns error message" do
        todo = create(:todo)
        todo.update(title: nil)
        expect(todo.errors[:key]).to include "Title can't be blank"
      end
    end
  end

  describe "#destroy" do
    after(:all) do
      Todo.destroy_all
    end

    it "decrease the count of todos" do
      todo = create(:todo)
      expect do
        todo.destroy
      end.to change(Todo, :count). by(-1)
    end
  end

  describe ".all" do
    before(:all) do
      3.times do |index|
        create(:todo, title: "Defence #{index}")
      end
    end

    context "when database is not empty" do
      after(:all) do
        Todo.destroy_all
      end

      it "returns all todos in the database" do
        todos = Todo.all
        expect(todos[0].title).to eq "Defence 0"
        expect(todos[1].title).to eq "Defence 1"
        expect(todos[2].title).to eq "Defence 2"
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
      after(:all) do
        Todo.destroy_all
      end

      it "returns the last created todo" do
        todo = create(:todo)
        expect(Todo.last.title).to eq todo.title
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
      after(:all) do
        Todo.destroy_all
      end

      it "return the first todo in the database" do
        todos = create_list(:todo, 3)
        expect(Todo.first.title).to eq todos[0].title
      end
    end

    context "when the database is empty" do
      it "returns nil" do
        expect(Todo.first).to eq nil
      end
    end
  end

  describe ".where" do
    after(:all) do
      Todo.destroy_all
    end

    it "returns matching records" do
      pending_todo = create(:todo, status: "Pending")
      completed_todo = create(:todo, status: "Completed")
      expect(Todo.where("status like ?", "%Pending%").first.status).to eq(
        pending_todo.status
      )

      expect(Todo.where("status like ?", "%Completed%").first.status).to eq(
        completed_todo.status
      )
    end
  end
end
