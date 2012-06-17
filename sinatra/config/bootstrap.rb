##
#
#ENV['GOOGLE_AUTH_URL'] = "https://www.google.com/accounts/AuthSubRequest"
require "erb"
require "dalli"
require "rubygems"
require "sinatra/base"
#require "sinatra/google-auth"

set :cache, Dalli::Client.new()

## Load helpers
Dir.glob( "helpers/*.rb" ).each do |fileName|
	require "%s/../%s" % [File.dirname(__FILE__),fileName]
end

## Load models
Dir.glob( "models/*.rb" ).each do |fileName|
	require "%s/../%s" % [File.dirname(__FILE__),fileName]
end

## Load mount points
Dir.glob( "mounts/*.rb" ).each do |fileName|
	require "%s/../%s" % [File.dirname(__FILE__),fileName]
end

