# app/services/mock_attempts_export.rb
require "csv"

class MockAttemptsExport
  def initialize(attempts)
    @attempts = attempts
  end

  def to_csv
    sections = all_sections

    CSV.generate(headers: true) do |csv|
      csv << headers(sections)

      @attempts.each do |attempt|
        csv << row_for(attempt, sections)
      end
    end
  end

  private

  def all_sections
    @attempts
      .flat_map { |a| a.exam.sections }
      .uniq
      .sort_by(&:id)
  end

  def headers(sections)
    base = %w[
      mock_id
      attempted_on
      exam
      total_attempted
      total_correct
      accuracy
    ]

    section_headers = sections.flat_map do |s|
      ["#{s.name}_attempted", "#{s.name}_correct"]
    end

    base + section_headers
  end

  def row_for(attempt, sections)
    base = [
      attempt.id,
      attempt.attempted_on,
      attempt.exam.name,
      attempt.total_attempted,
      attempt.total_correct,
      accuracy(attempt)
    ]

    results_by_section = attempt.mock_section_results.index_by(&:section_id)

    section_data = sections.flat_map do |section|
      sr = results_by_section[section.id]
      [sr&.attempted, sr&.correct]
    end

    base + section_data
  end

  def accuracy(attempt)
    return nil if attempt.total_attempted.zero?
    (attempt.total_correct.to_f / attempt.total_attempted * 100).round(1)
  end
end
