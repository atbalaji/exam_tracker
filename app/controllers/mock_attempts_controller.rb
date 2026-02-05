class MockAttemptsController < ApplicationController
  before_action :load_exams, only: [:new, :create]

  def index
    @mock_attempts = current_user.mock_attempts.includes(:exam, :mock_section_results).order(attempted_on: :desc)
  end

  def new
    @mock_attempt = MockAttempt.new
  end

  def create
    @mock_attempt = current_user.mock_attempts.new(mock_attempt_params)

    if @mock_attempt.save
      redirect_to @mock_attempt
    else
      render :new
    end
  end

  def show
    @mock_attempt = current_user.mock_attempts.find(params[:id])
    @sections = @mock_attempt.exam.sections
    @section_results = @mock_attempt.mock_section_results.includes(:section)

    @section_results_by_section_id = @section_results.index_by(&:section_id)
    @accuracy_trend = current_user.accuracy_trend_for(@mock_attempt.exam)
    @section_trends = current_user.section_accuracy_trend_for(@mock_attempt.exam)
    @weak_sections = current_user.weak_sections_for(@mock_attempt.exam)
  end

  def export
    attempts = current_user.mock_attempts.includes(:exam, mock_section_results: :section).order(:attempted_on)

    csv = MockAttemptsExport.new(attempts).to_csv
    send_data csv, filename: "mock_attempts_#{Date.today}.csv", type: "text/csv"
  end

  private

  def mock_attempt_params
    params.require(:mock_attempt).permit(:exam_id, :attempted_on, :source, :notes)
  end

  def load_exams
    @exams = Exam.all
  end
end
