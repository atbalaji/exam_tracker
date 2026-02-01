class DashboardsController < ApplicationController
  before_action :require_login

  def index
    @primary_exam = params[:exam_id].present? ? Exam.find(params[:exam_id]) : Exam.first
    @exam_mocks = current_user.mock_attempts.where(exam_id: @primary_exam.id).includes(mock_section_results: :section)
    @recent_mocks = @exam_mocks.sort_by(&:attempted_on).last(5)
    @total_mocks = @exam_mocks.size

    @weighted_average_accuracy = weighted_average_accuracy(@exam_mocks)
    @average_score = @total_mocks.zero? ? 0 : weighted_average_score(@exam_mocks, @primary_exam)
    @weak_sections = []
    @skipped_sections = []
    @exams = Exam.all
  end

  private

  def weighted_average_accuracy(mocks)
    total_attempted_cnt = 0
    total_correct_cnt = 0
    mocks.each do |mock|
      mock.mock_section_results.each do |sr|
        total_attempted_cnt += sr.attempted
        total_correct_cnt += sr.correct
      end
    end

    return 0 if total_attempted_cnt.zero?

    (total_correct_cnt.to_f / total_attempted_cnt * 100).round(1)
  end

  def weighted_average_score(mocks, exam)
    total_score = 0
    total_possible_score = 0

    mocks.each do |mock|
      mock.mock_section_results.each do |sr|
        total_score += sr.score
        total_possible_score += sr.total_questions * exam.marks_per_correct
      end
    end

    return 0 if total_possible_score.zero?

    (total_score.to_f / total_possible_score * 100).round(1)
  end

end
