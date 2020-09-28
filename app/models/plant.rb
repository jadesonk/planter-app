class Plant < ApplicationRecord
	has_many :users, through: :collections
end
