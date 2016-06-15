require "spec_helper"

RSpec.describe "Hyperloop Todo App", type: :feature, js: true do
  describe "Hompepage" do
    before(:all) do
      @todos = []

      3.times do
      todo = Todo.create(
        title: "Defence",
        body: "4",
        status: "Pending",
        created_at: Time.now
      )

      @todos << todo
      end
    end

    after(:all) do
      Todo.destroy_all
    end

    it "returns all todos in the database" do
      visit "/"

      expect(page).to have_content(@todos[0].title)
      expect(page).to have_content(@todos[1].title)
      expect(page).to have_content(@todos[2].title)
    end
  end

  describe "Creating Todo" do
    context "creating new todo with valid data" do
      after(:all) do
        Todo.destroy_all
      end

      it "returns newly created todo" do
        visit "/todo/new"

        expect(page).to have_content("Create New Todo")

        fill_in("todo[title]", with: "Holiday")
        fill_in("todo[body]", with: "Take a trip to Barbados")
        click_button("Create New")
        expect(page).to have_content("Holiday")
      end
    end
  end

  describe "updating" do
    after(:all) do
      Todo.destroy_all
    end

    context "updating todo with valid data" do
      it "returns newly created todo" do
        todo = Todo.create(
          title: "Defence",
          body: "4",
          status: "Pending",
          created_at: Time.now
        )

        visit "/todo/#{todo.id}/edit"

        expect(page).to have_content("Update Todo")

        fill_in("todo[title]", with: "Holiday")
        fill_in("todo[body]", with: "Take a trip to Barbados")
        click_button("Update Todo")
        expect(page).to have_content("Holiday")
      end
    end
  end

  describe "deletion" do
    after(:all) do
      Todo.destroy_all
    end

    it "removes deleted record from database" do
      todo = Todo.create(
        title: "Defence",
        body: "4",
        status: "Pending",
        created_at: Time.now
      )

      visit "/"
      find("#delete_button").click
      expect(Todo.find(todo.id)).to eq nil
    end
  end

  describe "Viewing Todo" do
    after(:all) do
      Todo.destroy_all
    end

    it "shows detail about todo" do
      todo = Todo.create(
        title: "Defence",
        body: "4",
        status: "Pending",
        created_at: Time.now
      )

      visit "/todo/#{todo.id}/show"

      expect(page).to have_content(todo.title)
      expect(page).to have_content(todo.body)
      expect(page).to have_content(todo.status)
      expect(page).to have_content(todo.created_at)

      expect(page).to have_button("DELETE")
      expect(page).to have_content("EDIT")
    end
  end
end
