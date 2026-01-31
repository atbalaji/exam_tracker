class Section < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :exam_id }
  validates :exam_id, presence: true

  belongs_to :exam
  has_many :mock_section_results
  has_many :questions
  has_many :quiz_attempts
end
