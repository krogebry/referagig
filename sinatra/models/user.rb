##
# Generic user object

class User
	include MongoMapper::Document

	key :name,String
	key :email,String
	key :access_token,String
	key :access_token_secret,String

end
