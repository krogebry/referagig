##
#
# set path to app that will be used to configure unicorn, 
# note the trailing slash in this example
#dir = "/home/krogebry/dev/bap/sinatra"
dir = File.dirname(File.expand_path( __FILE__ ))

worker_processes 2
working_directory dir

timeout 30

# Specify path to socket unicorn listens to, 
# we will use this in our nginx.conf later
#listen "#{@dir}/tmp/sockets/unicorn.sock", :backlog => 64
listen "%s/tmp/sockets/unicorn.sock" % dir, :backlog => 64

# Set process id path
#pid "#{@dir}/tmp/pids/unicorn.pid"
pid "%s/tmp/pids/unicorn.pid" % dir

# Set log file paths
stderr_path "%s/log/unicorn.stderr.log" % dir
stdout_path "%s/log/unicorn.stdout.log" % dir

