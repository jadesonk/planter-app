class Conversation < ApplicationRecord
  belongs_to :listing
  has_many :messages, dependent: :destroy
end
