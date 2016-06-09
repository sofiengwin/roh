require "roh"

$LOAD_PATH << File.join(File.dirname(__FILE__), "../app", "controllers")
$LOAD_PATH << File.join(File.dirname(__FILE__), "../app", "models")

module Hyperloop
  class Application < Roh::Application
  end
end
