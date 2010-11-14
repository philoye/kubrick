require 'bundler'
Bundler.setup
Bundler.require

require './../consumer/kubrick/balloon_fix'

file_name = File.join(File.dirname(__FILE__), "..", "config", "mongoid.yml")
@settings = YAML.load(ERB.new(File.new(file_name).read).result)

Mongoid.configure do |config|
  config.from_hash(@settings[ENV['KUBRICK_ENV'] || "development"])
end

configure do
  set :views, File.join(File.dirname(__FILE__),'views')
  set :public, File.join(File.dirname(__FILE__),'public')
  set :static, true
  set :haml => {:format => :html5}
  set :sass => {:load_paths => [File.join(Sinatra::Application.public,'scss')]}
end

get '/' do
  @last_fix = BalloonFix.last
  haml :index
end

get '/network.kml' do
  headers "Content-Type" => "application/vnd.google-earth.kml+xml"
  haml :network, :layout => false
end

get '/launch.kml' do
  headers "Content-Type" => "application/vnd.google-earth.kml+xml"
  @path = BalloonFix.all
  haml :kml, :layout => false
end
