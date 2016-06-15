require "spec_helper"

RSpec.describe "Creating Todo", type: :feature, js: true do
  after(:all) do
    Todo.destroy_all
  end

  context "creating new todo with valid data" do
    it "returns newly created todo" do
      visit "/todo/new"

      expect(page).to have_content("Create New Todo")

      fill_in("todo[title]", with: "Holiday")
      fill_in("todo[body]", with: "Take a trip to Barbados")
      click_button("Create New")
      expect(page).to have_content("Holiday")
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
end
