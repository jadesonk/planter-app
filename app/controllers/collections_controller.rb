class CollectionsController < ApplicationController
	def index
		@collections = Collection.all		
	end

	def show
		@collection.find_by(user_id: current_user.id)
	end
end
