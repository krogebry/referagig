##
# Environment setup
require 'sinatra'
require 'pp'
require 'erb'
require 'yaml'
require 'dalli'
require 'oauth'
require 'logger'
require 'multi_json'
require 'mongo_mapper'
require 'google/api_client'
require 'rack/session/dalli'

ENV['RACK_ENV'] ||= 'development'
FS_APPLICATION_ROOT = File::dirname(File::expand_path( "..",__FILE__ ))

begin
	require "%s/mounts/main.rb" % File.dirname(File.expand_path( __FILE__ )).gsub( /config/,'' )
	["helpers", "models", "mounts", "models/auth", "libs" ].each do |path|
		Dir.glob(File.join(path, '*.rb')).sort.each { |f| require "%s/../%s" % [File.dirname(__FILE__),f] }
	end
	require "%s/environments/%s" % [File.dirname(__FILE__),ENV['RACK_ENV']]

	## Pull in the linkedin config
	LinkedInConfig = YAML::load_file( "%s/config/linkedin.yaml" % FS_APPLICATION_ROOT )

	# Set up LinkedIn specific OAuth API endpoints
	opts = { 
		:site => LinkedInConfig["api_host"],
		:authorize_path => LinkedInConfig['authorize_path'],
		:access_token_path => LinkedInConfig['access_token_path'],
		:request_token_path => LinkedInConfig['request_token_path']
	}
	pp opts
	LinkedInConsumer = OAuth::Consumer.new( LinkedInConfig["api_key"], LinkedInConfig["api_secret_key"], opts )

	## Create db connection
	MongoMapper.connection = Mongo::Connection.new( Database[:hostname], Database[:port], :logger => Logger.new( "log/mongo.log" ) )
	MongoMapper.database = Database[:name]

rescue => e
	puts "Failed to load asset: %s" % e
	puts e.backtrace
	exit

end
