class MockSectionResult < ApplicationRecord
  validates :mock_attempt_id, presence: true
  validates :section_id, presence: true, uniqueness: { scope: :mock_attempt_id }

  validates :attempted, numericality: { greater_than_or_equal_to: 0 }
  validates :correct, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :attempted }

  belongs_to :mock_attempt
  belongs_to :section
end
