class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :listings, dependent: :destroy
  has_many :conversations, through: :listings
  has_many :messages
  has_many :questions
  has_many :answers, through: :questions
  has_many :plants, through: :collections
end
