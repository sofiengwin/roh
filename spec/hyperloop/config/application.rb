require "roh"

$LOAD_PATH << File.join(File.dirname(__FILE__), "../app", "controllers")

module Hyperloop
  class Application < Roh::Application
  end
end
