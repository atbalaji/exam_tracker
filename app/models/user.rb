class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  has_many :mock_attempts
  has_many :quiz_attempts
  has_many :questions, foreign_key: :created_by_id


  def accuracy_trend_for(exam)
    mock_attempts
      .where(exam: exam)
      .order(:attempted_on)
      .map do |attempt|
        {
          date: attempt.attempted_on,
          accuracy: attempt.accuracy
        }
      end
  end
end
