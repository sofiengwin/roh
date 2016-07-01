require "spec_helper"

describe "Validations" do
  describe "#validate_length" do
    context "when length is too short" do
      it "returns 'length too long' error message" do
        todo = create(:todo, title: "T")
        expect(todo.errors[:title]).to include "Title is too short"
        Todo.destroy_all
      end
    end

    context "when length is too long" do
      it "returns 'length too short' error message" do
        todo = create(
          :todo,
          title: "A very long title that will trigger a validation error"
        )
        expect(todo.errors[:title]).to include "Title is too long"
        Todo.destroy_all
      end
    end
  end

  describe "#validate_presence" do
    it "returns 'can\'t be blank' error message" do
      todo = create(:todo, title: "")
      expect(todo.errors[:title]).to include "Title can't be blank"
      Todo.destroy_all
    end
  end

  describe "#validate_format" do
    it "returns 'pattern doesn\'t match' error message" do
      todo = create(:todo, title: "1234")
      expect(todo.errors[:title]).to include "Title didn't match pattern"
      Todo.destroy_all
    end
  end

  describe "#validate_uniqueness" do
    it "returns 'record already exist' error message" do
      create(:todo, title: "Title")
      todo = create(:todo, title: "Title")
      expect(todo.errors[:title]).to include "Title already exist"
    end
  end
end
