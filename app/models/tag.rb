class Tag < ApplicationRecord
  has_many :listings, through: :listings_tags

  validates :name, presence: true
end
