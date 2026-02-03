class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  has_many :mock_attempts
  has_many :quiz_attempts
  has_many :questions, foreign_key: :created_by_id


  def accuracy_trend_for(exam)
    mock_attempts.where(exam: exam).order(:attempted_on).map do |attempt|
      {
        date: attempt.attempted_on,
        accuracy: attempt.accuracy
      }
    end
  end

  def each_section_result_for(exam)
    mock_attempts.where(exam: exam).includes(mock_section_results: :section).order(:attempted_on).each do |attempt|
      attempt.mock_section_results.each do |sr|
        yield(attempt, sr)
      end
    end
  end

  def section_accuracy_trend_for(exam)
    res = {}

    each_section_result_for(exam) do |attempt, sr|
      res[sr.section.id] ||= []
      res[sr.section.id] << {
        section_name: sr.section.name,
        date: attempt.attempted_on,
        accuracy: sr.attempted.zero? ? 0 : ((sr.correct.to_f / sr.attempted) * 100).round(1)
      }
    end

    res
  end

  def weak_sections_for(exam)
    data = {}

    each_section_result_for(exam) do |_attempt, sr|
      next if sr.attempted.zero?

      entry = (data[sr.section.id] ||= { section_name: sr.section.name, correct: 0, attempted: 0, mocks: 0 })
      entry[:correct]   += sr.correct
      entry[:attempted] += sr.attempted
      entry[:mocks]     += 1
    end

    data
      .select { |_section, v| v[:mocks] >= 3 }
      .map do |_section, v|
        accuracy = (v[:correct].to_f / v[:attempted] * 100).round(1)
        { section_name: v[:section_name], accuracy: accuracy }
      end
      .select { |h| h[:accuracy] < 60 }
      .sort_by { |h| h[:accuracy] }
  end

  # def skipped_sections_for(exam)
  #   data = {}

  #   each_section_result_for(exam) do |attempt, sr|
  #     entry = (data[sr.section.id] ||= { section_name: sr.section.name, attempted: 0, total: 0, mocks: 0})
  #     entry[:attempted] += sr.attempted
  #     entry[:total] = sr.total_questions
  #     entry[:mocks] += 1
  #   end

  #   data.select { |_section, v| v[:mocks] >= 3 && v[:total] > 0 }
  #     .map do |_section, v|
  #       attempt_ratio = (v[:attempted].to_f / v[:total] * 100).round(1)
  #       { section_name: v[:section_name], attempt_ratio: attempt_ratio }
  #     end
  #     .select { |h| h[:attempt_ratio] < 40 }
  #     .sort_by{ |h| h[:attempt_ratio] }
  # end

  def section_coverage_for(exam)
    data = {}

    each_section_result_for(exam) do |_attempt, sr|
      entry = (data[sr.section.id] ||= {
        section_name: sr.section.name,
        attempted: 0,
        total: 0,
        mocks: 0
      })

      entry[:attempted] += sr.attempted
      entry[:total] = sr.total_questions
      entry[:mocks] += 1
    end

    data
  end

  def section_coverage_summary_for(exam)
    section_coverage_for(exam)
      .map do |_id, v|
        next if v[:total].zero?

        {
          section_name: v[:section_name],
          coverage: (v[:attempted].to_f / v[:total] * 100).round(1),
          mocks: v[:mocks]
        }
      end.compact
  end

  def skipped_sections_for(exam)
    section_coverage_summary_for(exam)
      .select { |h| h[:mocks] >= 3 && h[:coverage] < 40 }
      .sort_by { |h| h[:coverage] }
  end


end
