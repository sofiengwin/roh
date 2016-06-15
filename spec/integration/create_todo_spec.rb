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
end
