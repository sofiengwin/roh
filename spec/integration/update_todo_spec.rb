require "spec_helper"

RSpec.describe "Update Todo", type: :feature, js: true do

  after(:all) do
    Todo.destroy_all
  end

  context "updating todo with valid data" do
    it "returns newly created todo" do
      todo = Todo.new(
        title: "Defence",
        body: "4",
        status: "Pending",
        created_at: Time.now
      )
      todo.save

      visit "/todo/#{todo.id}/edit"

      expect(page).to have_content("Update Todo")

      fill_in("todo[title]", with: "Holiday")
      fill_in("todo[body]", with: "Take a trip to Barbados")
      click_button("Update Todo")
      expect(page).to have_content("Holiday")
    end
  end
end
