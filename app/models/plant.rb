class Plant < ApplicationRecord
	has_many :users, through: :collections
	has_many :collections, dependent: :destroy
	has_many_attached :photos
end
