require 'open-uri'

class PlantsController < ApplicationController
	before_action :index, only: [:show]

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

	def show
			slug = params[:slug]
			species_url = "https://trefle.io/api/v1/species/#{slug}?token=#{get_api_key}"
			response = open(species_url).read
			result = JSON.parse(response)
			@plants = result["data"]
			@flowers = @plants["images"]["flower"]
	end

	private

	def	get_api_key
		ENV['TREFLE_API_KEY']
	end


end

