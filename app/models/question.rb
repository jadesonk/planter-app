class Question < ApplicationRecord
  belongs_to :user
  has_many :answers

  validates :question_text, presence: true
end
