require 'open-uri'

class PlantsController < ApplicationController
	before_action :index, only: [:show, :create]

	def index
		# display collections on index page
		@collections = Collection.all
		@plant = Plant.all

	end

	def slug_index
		query = params[:query]
		key = get_api_key
		if query.nil? || @query == ""
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

		#show user who contributed to the plant
		# @collections = Collection.all
		# @collections.each do |collection|
		# 	collection.plant_id = @plant
		# 	@user_id = collection.user_id
		# end
	end

	def edit
		@plant = Plant.find(params[:id])
	end
	
	def	update
		@plant = Plant.find(params[:id])
		@plant.update(plant_params)
		redirect_to plant_path(@plant)
	end

	def destroy
		@plant = Plant.find(params[:id])
		@plant.destroy
		redirect_to stories_path
	end

	def collection
		@collections = Collection.where(user_id: current_user.id)
		
		@plant_id_array = []
		@collections.each do |collection|
			@plant_id_array << collection[:plant_id]
		end

	end


	private

	def plant_params
		params.require(:plant).permit(:common_name, :description, :sun, :water, :max_height, :duration_to_harvest, :trellis_support, photos: [])
	end

	private

	def	get_api_key
		ENV['TREFLE_API_KEY']
	end

end

