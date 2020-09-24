class ListingsController < ApplicationController
  before_action :set_listings, only: [:index, :filter]

  def index
    @tags = Tag.all
  end

  def show
    @listing = Listing.find(params[:id])
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    if @listing.save
      redirect_to @listing
    else
      render :new
    end
  end

  def filter
    initiate_select
  end

  private

  def set_listings
    @listings = Listing.all
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :listing_type).tap do |whitelisted|
      # whitelist tags and convert value to integer
      whitelisted[:tag_ids] = params[:listing][:tag_ids].drop(1).map { |i| i.to_i }
    end
  end

  def initiate_select
    tag = params[:select]
    if tag.present?
      @listings = Listing.filter_by_tag(tag)
    end
  end
end
