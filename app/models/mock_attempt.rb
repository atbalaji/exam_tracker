class MockAttempt < ApplicationRecord
  validates :user_id, presence: true
  validates :exam_id, presence: true
  validates :attempted_on, presence: true

  belongs_to :user
  belongs_to :exam
  has_many :mock_section_results

  def total_attempted
    mock_section_results.sum(:attempted)
  end

  def total_correct
    mock_section_results.sum(:correct)
  end

  def total_score
    mock_section_results.sum(&:score)
  end

  def accuracy
    return 0 if total_attempted.zero?

    (total_correct.to_f / total_attempted) * 100
  end
end
