class MockSectionResult < ApplicationRecord
  validates :mock_attempt_id, presence: true
  validates :section_id, presence: true, uniqueness: { scope: :mock_attempt_id }

  validates :total_questions, presence: true, numericality: { greater_than: 0 }
  validates :attempted, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :correct, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :attempted }

  validate :logical_consistency

  belongs_to :mock_attempt
  belongs_to :section

  def wrong
    attempted - correct
  end

  def score
    exam = mock_attempt.exam

    (correct.to_i * exam.marks_per_correct)  - (wrong * exam.negative_mark)
  end

  private

  def logical_consistency
    if attempted > total_questions
      errors.add(:attempted, "Cannot exceed total questions")
    end

    if correct > attempted
      errors.add(:correct, "Cannot exceed attempted questions")
    end
  end
end
