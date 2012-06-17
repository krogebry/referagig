##
# Capification

load 'deploy'

# Uncomment if you are using Rails' asset pipeline
# load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :deploy do
	task :finalize_update do
	end

	task :sync do
		roles[:app].each do |server|
			cmd = "rsync --exclude 'three.js*' -r '%s' %s@%s:%s/current/" % [ ".", user, server,deploy_to ]
			#puts "CMD: %s" % cmd
			puts "Sending to: %s" % server
			`#{cmd}`
		end
	end

	task :link_roles do
		Dir.glob( "chef/roles/*.json" ).each do |path|
			roleFileName = File::basename( path )
			run( "if [ ! -L /var/chef-solo/roles/%s ]; then ln -s /var/www/%s/current/chef/roles/%s /var/chef-solo/roles/%s; fi" % [
				roleFileName, application, roleFileName, roleFileName
			])
		end
	end
	after "deploy:create_symlink", "deploy:link_roles"

end
