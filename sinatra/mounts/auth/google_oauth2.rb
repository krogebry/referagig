##
# Main mount points

class Application < Sinatra::Base

	get '/google_oauth2_authorize' do
		@user = BAP::User.find( session[:user_id] )
		oauth_yaml = YAML.load_file( "%s/config/google-api.yaml"   % settings.root )
		@client = Google::APIClient.new
		@client.authorization.client_id = oauth_yaml["client_id"]
		@client.authorization.client_secret = oauth_yaml["client_secret"]
		@client.authorization.scope = oauth_yaml["scope"]
		@client.authorization.redirect_uri = to('/google_oauth2_call_back')
		@client.authorization.code = params[:code] if params[:code]
		redirect @client.authorization.authorization_uri.to_s, 303
	end

	get '/google_oauth2_call_back' do
		@user = BAP::User.find( session[:user_id] )
		oauth_yaml = YAML.load_file( "%s/config/google-api.yaml"   % settings.root )
		@client = Google::APIClient.new
		@client.authorization.client_id = oauth_yaml["client_id"]
		@client.authorization.client_secret = oauth_yaml["client_secret"]
		@client.authorization.scope = oauth_yaml["scope"]
		@client.authorization.redirect_uri = to('/google_oauth2_call_back')
		@client.authorization.code = params[:code] if params[:code]
		#@client.authorization.fetch_access_token!

  	## Persist the token here
		puts "tokenId: %s" % session[:token_id]
		auth = @client.authorization
  	if session[:token_id]
			tp = @user.google_oauth2_token_pair
			tp.update_token!( auth )
  	else
    	tp = GoogleOauth2TokenPair.new({ 
				:user_id => @user.id,
				:issued_at => auth.issued_at,
				:expires_in => auth.expires_in,
				:access_token => auth.access_token,
				:refresh_token => auth.refresh_token
			})
			@user.google_oauth2_token_pair = tp
			tp
  	end

		@user.save!
  	session[:token_id] = tp.id
  	redirect to('/tokens')
	end

end 
