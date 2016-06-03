require "rspec"
require "rack/test"

ENV["RACK_ENV"] = "test"
require_relative "hyperloop/config/application.rb"

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'roh'
