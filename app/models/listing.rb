class Listing < ApplicationRecord
  belongs_to :user
  has_many :tags, through: :listings_tags
  has_many :conversations, dependent: :destroy
  has_many :messages, through: :conversations

  validates :title, presence: true
  validates :description, presence: true

  enum listing_type: { swap: 0, want: 1, free: 2 }
  enum status: { open: 0, closed: 1 }
end
