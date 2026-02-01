class Exam < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  validates :marks_per_correct, :negative_mark, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_many :sections
  has_many :mock_attempts

  def each_section_result
    mock_attempts.includes(mock_section_results: :section).order(:attempted_on).each do |attempt|
      attempt.mock_section_results.each do |sr|
        yield(attempt, sr)
      end
    end
  end

  def section_accuracy_trend
    result = {}

    each_section_result do |attempt, sr|
      result[sr.section.name] ||= []
      result[sr.section.name] << {
        date: attempt.attempted_on,
        accuracy: sr.attempted.zero? ? 0 : (sr.correct.to_f / sr.attempted) * 100
      }
    end

    result
  end

  def weak_sections
    data = {}

    each_section_result do |_attempt, sr|
      next if sr.attempted.zero?

      data[sr.section.name] ||= []
      data[sr.section.name] << (sr.correct.to_f / sr.attempted) * 100
    end

    data
      .select { |_section, scores| scores.size >= 3 }
      .map do |section, scores|
        avg = scores.sum / scores.size
        { section: section, average_accuracy: avg }
      end
      .select { |h| h[:average_accuracy] < 60 }
      .sort_by { |h| h[:average_accuracy] }
  end
end
