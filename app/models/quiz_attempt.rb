class QuizAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :section
  has_many :quiz_question_attempts
end
