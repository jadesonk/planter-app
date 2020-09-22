class CreateJoinTableListingsTags < ActiveRecord::Migration[6.0]
  def change
    create_join_table :listings, :tags do |t|
      # t.index [:listing_id, :tag_id]
      # t.index [:tag_id, :listing_id]
    end
  end
end
