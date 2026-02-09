class MockAttemptsController < ApplicationController
  before_action :load_exams, only: [:new, :create]
  before_action :set_mock_attempt, only: [:show, :edit, :update, :destroy]

  def index
    @exams = Exam.order(:name)
    @mock_attempts = current_user.mock_attempts

    if params[:exam_id].present?
      @mock_attempts = @mock_attempts.for_exam(params[:exam_id])
    end

    @mock_attempts = @mock_attempts.includes(:exam, :mock_section_results)
                      .order(attempted_on: :desc)
  end

  def new
    @mock_attempt = MockAttempt.new
  end

  def create
    @mock_attempt = current_user.mock_attempts.new(mock_attempt_params)

    if @mock_attempt.save
      redirect_to @mock_attempt
    else
      @exams = Exam.all
      render :new, status: :unprocessable_entity
    end
  end

  def show
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

  def edit
  end

  def update
    if @mock_attempt.update(mock_attempt_update_params)
      redirect_to @mock_attempt, notice: "Mock attempt updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @mock_attempt.destroy

    redirect_to mock_attempts_path, notice: "Mock attempt deleted successfully"

  rescue ActiveRecord::RecordNotFound
    redirect_to  mock_attempts_path, alert: "Mock attempt not found"
  end

  private

  def mock_attempt_params
    params.require(:mock_attempt).permit(:exam_id, :attempted_on, :source, :notes)
  end

  def mock_attempt_update_params
    params.require(:mock_attempt).permit(:attempted_on, :source, :notes)
  end

  def load_exams
    @exams = Exam.all
  end

  def set_mock_attempt
    @mock_attempt = current_user.mock_attempts.find(params[:id])
  end
end
