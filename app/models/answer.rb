class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :answer_text, presence: true
end
