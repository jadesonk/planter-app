require 'open-uri'

class PlantsController < ApplicationController
	before_action :index, only: [:show, :create]

	def index
		query = params[:query]
		key = get_api_key
		if query.nil? || query == ""
			url = "https://trefle.io/api/v1/plants?token=#{key}"
		else
			url = "https://trefle.io/api/v1/plants/search?token=#{key}&q=#{query}"
		end
		response = open(url).read
		result = JSON.parse(response)
		@plants = result["data"]

	end

	def slug_show
			slug = params[:slug]
			species_url = "https://trefle.io/api/v1/species/#{slug}?token=#{get_api_key}"
			response = open(species_url).read
			result = JSON.parse(response)
			@plants = result["data"]
			@flowers = @plants["images"]["flower"]
	end

	def new
		@plant = Plant.new
	end
	
	def create
		@plant = Plant.new(plant_params)
		# why is @collection returning nil?
		@collection = Collection.find_or_create_by(user_id: current_user.id)
		@collection.plant = @plant
		@plant.save
		if @plant.save
			@new_collection = Collection.create!(user_id: current_user.id, plant_id: @plant.id)
			redirect_to plant_path(@plant)
		else
			render :new
		end
	end

	def show
		@plant = Plant.find(params[:id])
		@collection = Collection.find_or_create_by(user_id: current_user.id)
	end
	

	private

	def plant_params
		params.require(:plant).permit(:common_name, :sun, :water, :max_height, :duration_to_harvest, :trellis_support)
	end

	private

	def	get_api_key
		ENV['TREFLE_API_KEY']
	end

end

