require 'spec_helper'

APP_ROOT ||= __dir__ + "/hyperloop"

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
        get "/todos"
        expect(last_response.body).to eq "Test"
      end
    end
  end
end
