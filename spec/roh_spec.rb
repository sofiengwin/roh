require 'spec_helper'

describe Roh do
  it 'has a version number' do
    expect(Roh::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end

HyperloopApplication = Hyperloop::Application.new

describe "Hyperloop App" do
  include Rack::Test::Methods


  def app
    require "hyperloop/config/routes.rb"
    HyperloopApplication
  end

  describe "GET index" do
    context "when making valid get request" do
      it "returns a list of all my todos" do
        get "/todo/144/edit"
        expect(last_response).to eq "Test"
      end
    end
  end
end