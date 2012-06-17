##
# Main mount points

class Application < Sinatra::Base

	## Register auth hook for authenticated pages.
	register do
		def auth( type )
			condition do
				@user = BAP::User.find( session[:user_id] )
				if( @user == nil )
					puts "Redirecting to /login because @user is nil."
					redirect "/login" 
				end
			end
		end
	end

	## Main entry point
	get "/" do
		#job = Job.new({
			#:name => "blah",
			#:display => "Blah"
		#})
		#job.save!
		jobs = Job.all()

		#user = User.new({
			#:email => "bryan.kroger@gmail.com",
			#:access_token => "b8c35009-6330-4d76-9691-c4b80b73ba2b",
			#:access_token_secret => "0e37cb72-9361-4887-b852-2562e119216a"
		#})
		#user.save!
		user = User.first({ :email => "bryan.kroger@gmail.com" })
		#pp user

		access_token = OAuth::AccessToken.new( LinkedInConsumer, user.access_token, user.access_token_secret ) 
		pp access_token

		fields = ['first-name', 'last-name', 'headline', 'industry', 'num-connections'].join(',')
		# Make a request for JSON data
		json_txt = access_token.get( "/v1/people/~:(%s)" % fields, 'x-li-format' => 'json' ).body
		profile = JSON.parse( json_txt )
		#puts JSON.pretty_generate(profile)

		erb :index,{},{
			:jobs => jobs,
			:user => user,
			:profile => profile
		}
	end

	## Login page
	get "/login" do
		erb :login, {}, {}
	end

	## Login action
	post "/login" do
		user = BAP::User.find_by_auth( params[:username],params[:password] )
		if(user.count == 0)
			redirect url( "/create_account" )
			halt
		end
		session[:user_id] = user.first.id
		redirect "/"
	end

	## Logout page, kill session and redirect to "/".
	get "/logout/?" do
		session.clear
		session = []
		redirect "/login"
	end

end 
