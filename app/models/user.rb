class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy

  has_many :receiving_conversations, through: :listings, source: :conversations
  has_many :sending_conversations, class_name: "Conversation", foreign_key: "initiating_user_id"

  has_many :messages
  has_many :questions
  has_many :answers, through: :questions
  has_many :plants, through: :collections
end
