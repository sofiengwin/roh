require "spec_helper"

RSpec.describe "Hyperloop Todo App", type: :feature do
  describe "Hyperloop todo app hompepage" do
    it "returns all todos in the database" do
      todos = create_list(:todo, 3)
      visit "/"

      expect(page).to have_content(todos[0].title)
      expect(page).to have_content(todos[1].title)
      expect(page).to have_content(todos[2].title)
      Todo.destroy_all
    end
  end

  describe "Creating a new todo" do
    context "when creating new todo with valid data" do
      it "returns newly created todo" do
        visit "/todo/new"

        fill_in("todo[title]", with: "Holiday")
        fill_in("todo[body]", with: "Take a trip to Barbados")
        click_button("Create New")
        expect(page).to have_content("Holiday")
        Todo.destroy_all
      end
    end
  end

  describe "Updating a todo" do
    context "when updating todo with valid data" do
      it "returns newly created todo" do
        todo = create(:todo)

        visit "/todo/#{todo.id}/edit"

        expect(page).to have_content("Update Todo")

        fill_in("todo[title]", with: "Holiday")
        fill_in("todo[body]", with: "Take a trip to Barbados")
        click_button("Update Todo")
        expect(page).to have_content("Holiday")
        Todo.destroy_all
      end
    end
  end

  describe "Deleting a todo" do
    it "removes deleted record from database" do
      todo = create(:todo)

      visit "/"
      find("#delete_button").click
      expect(Todo.find(todo.id)).to eq nil
      Todo.destroy_all
    end
  end

  describe "Viewing a todo" do
    it "shows detail about todo" do
      todo = create(:todo)

      visit "/todo/#{todo.id}/show"

      expect(page).to have_content(todo.title)
      expect(page).to have_content(todo.body)
      expect(page).to have_content(todo.status)
      expect(page).to have_content(todo.created_at)

      expect(page).to have_button("DELETE")
      expect(page).to have_content("EDIT")
      Todo.destroy_all
    end
  end
end
