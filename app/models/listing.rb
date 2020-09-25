class Listing < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :conversations, dependent: :destroy
  has_many :messages, through: :conversations
  has_many_attached :photos

  validates :title, presence: true
  validates :description, presence: true

  enum listing_type: { swap: 0, want: 1, free: 2 }
  enum status: { open: 0, closed: 1 }

  def self.filter_by_tag tag
    Tag.find_by(name: tag).listings
  end
end
