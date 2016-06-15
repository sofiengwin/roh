require "spec_helper"

RSpec.describe Roh::BaseModel do

  describe "#save" do
    after(:all) do
      Todo.destroy_all
    end

    context "when creating todo with valid details" do
      it "returns newly created todo" do
        todo = Todo.new(title: "Livingston", body: "25", status: "Complete")
        new_todo = todo.save
        expect(new_todo.title).to eq "Livingston"
      end

      it "increases the count of todos" do
        todo = Todo.new(title: "Livingston", body: "25", status: "Complete")
        expect do
          todo.save
        end.to change(Todo, :count).by 1
      end
    end

    context "when creating todo with invalid data" do
      it "returns error message" do
        todo = Todo.new(title: nil, body: nil, status: "Complete")
        new_todo = todo.save
        expect(new_todo.errors[:key]).to eq "Title can't be blank"
      end

      it "doesn't increase count of todos" do
        todo = Todo.new(title: nil, body: "25", status: "Complete")
        expect do
          todo.save
        end.to change(Todo, :count).by 0
      end
    end
  end

  describe "#update" do
    before(:all) do
      @todo = Todo.create(title: "Livingston", body: "25", status: "Complete")
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
        todo = Todo.create(title: "Livingston", body: "25", status: "Complete")
        todo.update(title: nil)
        expect(todo.errors[:key]).to eq "Title can't be blank"
      end
    end
  end

  describe "#destroy" do
    after(:all) do
      Todo.destroy_all
    end

    it "decrease the count of todos" do
      todo = Todo.create(title: "Livingston", body: "25", status: "Complete")
      expect do
        todo.destroy
      end.to change(Todo, :count). by(-1)
    end
  end

  describe ".all" do
    before(:all) do
      3.times do |index|
        Todo.create(title: "Defence #{index}", body: "25", status: "Complete")
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

    end

    context "when database is empty" do

    end
  end
end
