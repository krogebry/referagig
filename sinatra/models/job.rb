##
# Generic user object

class Job
	include MongoMapper::Document

	key :name,String
	key :display,String

	#scope :find_by_auth, lambda { |username,password| where( :username => username, :password => password ) }
	#key :username,String,:required => true
	#key :password,String,:required => true
	#key :google_oauth2_token_pair,GoogleOauth2TokenPair
	#many :watchlist_items, { :class => BAP::WatchlistItem }

	def getWatchlist( type )
		self.watchlist_items.select{|o| o.className == type }
	end

	def watchObject( obj )
		return if(self.isWatching?( obj ))
		self.watchlist_items << BAP::WatchlistItem.new({ :objectId => obj.id, :className => obj.class })
		self.save!
	end

	def unWatchObject( obj )
		new_list = self.watchlist_items.select{|o| !(o.className == obj.class.to_s && o.objectId.to_s == obj.id.to_s) }
		self.watchlist_items = new_list
		self.save!
	end

	def isWatching?( obj )
		self.watchlist_items.select{|o| o.className == obj.class.to_s && o.objectId.to_s == obj.id.to_s }.size == 0 ? false : true
	end

end
