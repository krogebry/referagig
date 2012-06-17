##
# Config for rack up.
require "%s/config/environment" % File.dirname(__FILE__)

use Rack::CommonLogger

Sinatra::Base.set :static, true
Sinatra::Base.set :root, File.dirname(File.expand_path( __FILE__ )).gsub( /mounts/,'' )
Sinatra::Base.set :dump_errors, true
Sinatra::Base.set :show_exceptions, true

use Rack::ShowExceptions if ENV['RACK_ENV'] == 'development'
use Rack::MethodOverride
#use Rack::Session::Cookie
use Rack::Session::Dalli , :memcache_server => MemcacheServers
#use Rack::Session::Memcache, :servers => MemcacheServers
#use Rack::Flash, accessorize: [:error, :success]

Sinatra::Base.helpers Sinatra::AppHelpers

run Application
