##
# Base helper

module Sinatra
	module AppHelpers
		def is_user?
			#puts "Checking for user: %s" % @user.inspect
			@user != nil
		end
	end
end


