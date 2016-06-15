require "spec_helper"

RSpec.describe "Utility Methods" do
  describe "#to_snake_case" do
    context "PersonController" do
      it { expect("PersonController".to_snake_case).to eq "person_controller" }
    end

    context "Person" do
      it { expect("Person".to_snake_case).to eq "person" }
    end

    context "Todo::Person" do
      it { expect("Todo::Person".to_snake_case).to eq "todo/person" }
    end

    context "PERSONController" do
      it { expect("PERSONController".to_snake_case).to eq "person_controller" }
    end

    context "personcontroller" do
      it { expect("personcontroller".to_snake_case).to eq "personcontroller" }
    end

    context "person" do
      it { expect("person".to_snake_case).to eq "person" }
    end
  end

  describe "#to_camel_case" do
    context "person_controller" do
      it { expect("person_controller".to_camel_case).to eq "PersonController" }
    end

    context "person__todo_app" do
      it { expect("person__todo_app".to_camel_case).to eq "PersonTodoApp" }
    end

    context "person" do
      it { expect("person".to_camel_case).to eq "Person" }
    end
  end
end
