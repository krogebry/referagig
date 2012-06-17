##
#
class GoogleOauth2TokenPair
	include MongoMapper::EmbeddedDocument
	#belongs_to :user, BAP::User

	key :user_id, ObjectId
  key :issued_at, Integer
  key :expires_in, Integer
  key :access_token, String
  key :refresh_token, String

  def update_token!(object)
		#puts "Updating token: %s" % object.refresh_token
    self.issued_at = object.issued_at
    self.expires_in = object.expires_in
    self.access_token = object.access_token
    self.refresh_token = object.refresh_token
		#self.save!
		#puts "Done updating token: %s" % self.inspect
  end

  def to_hash
    return {
      :issued_at => Time.at(@issued_at),
      :expires_in => @expires_in,
      :access_token => @access_token,
      :refresh_token => @refresh_token
    }
  end

#if(@user.google_oauth2_token_pair != nil)
#puts "Checking for goauth2 token pair"
#tp = @user.google_oauth2_token_pair
#pp tp.to_hash

#oauth_yaml = YAML.load_file( "%s/config/google-api.yaml"   % settings.root )
#@client = Google::APIClient.new
#@client.authorization.client_id = oauth_yaml["client_id"]
#@client.authorization.client_secret = oauth_yaml["client_secret"]
#@client.authorization.scope = oauth_yaml["scope"]
#@client.authorization.redirect_uri = to('/google_oauth2_call_back')
##@client.authorization.code = params[:code] if params[:code]

#@client.authorization.update_token!(tp.to_hash)
#if @client.authorization.refresh_token && @client.authorization.expired?
#puts "\tFeatching access token"
##pp @client.authorization
#@client.authorization.fetch_access_token!
#@user.google_oauth2_token_pair.update_token!( @client.authorization )
#@user.save!
#puts "\tDone Featching access token"
#end
#unless @client.authorization.access_token || request.path_info =~ /^\/oauth2/
#redirect to('/google_oauth2_authorize')
#end
#@calendar = @client.discovered_api('calendar', 'v3')
#puts "Calendar:"
#pp @calendar
#end

end
