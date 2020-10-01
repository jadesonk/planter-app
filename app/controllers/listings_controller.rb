class ListingsController < ApplicationController
  before_action :set_listings, only: [:index, :filter]

  def index
    @tags = Tag.all
    @listing_types = [ 'swap', 'want', 'free' ]
  end

  def show
    @listing = Listing.find(params[:id])
    @message = Message.new
    authorize @listing

    # set variable to determine if listing owner
    @i_am_listing_owner = @listing.user == current_user
  end

  def new
    @listing = Listing.new
    authorize @listing
  end

  def create
    @listing = Listing.new(listing_params)
    @listing.user = current_user
    authorize @listing
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
    # policy_scope breaking filter
    @listings = policy_scope(Listing).where('expiry_date >= ?', Date.today)
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :listing_type, :expiry_date, photos: [], tag_ids: [])
  end

  def initiate_select
    tag = params[:select]
    if tag.present?
      @listings = Listing.filter_by_tag(tag)
      authorize @listings
    end
  end
end
