require 'mongoid'

require './kubrick/balloon_receiver'
require './kubrick/balloon_fix'

file_name = File.join(File.dirname(__FILE__), "config", "mongoid.yml")
@settings = YAML.load(ERB.new(File.new(file_name).read).result)

Mongoid.configure do |config|
  config.from_hash(@settings[ENV['KUBRICK_ENV'] || "development"])
end

BalloonReceiver.new.go

