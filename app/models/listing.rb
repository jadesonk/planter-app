class Listing < ApplicationRecord
  belongs_to :user
  has_many :tags, through: :listings_tags
  has_many :conversations, dependent: :destroy
  has_many :messages, through: :conversations

  validates :title, presence: true
  validates :description, presence: true
end
