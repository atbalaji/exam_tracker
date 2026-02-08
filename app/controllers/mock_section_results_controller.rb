class MockSectionResultsController < ApplicationController
  def create
    results = params[:results] || []
    filled_results = results.reject do |r|
      r[:total_questions].blank? &&
      r[:attempted].blank? &&
      r[:correct].blank?
    end

    if filled_results.empty?
      redirect_back fallback_location: root_path,
        alert: "Enter at least one section result"
      return
    end

    mock_attempt = current_user.mock_attempts.find(
      filled_results.first[:mock_attempt_id]
    )

    ActiveRecord::Base.transaction do
      filled_results.each do |result|
        msr = MockSectionResult.find_or_initialize_by(
          mock_attempt: mock_attempt,
          section_id: result[:section_id]
        )

        msr.assign_attributes(
          total_questions: result[:total_questions],
          attempted: result[:attempted],
          correct: result[:correct]
        )

        msr.save!
      end
    end

    redirect_to mock_attempt_path(mock_attempt),
      notice: "Section results saved"

  rescue ActiveRecord::RecordInvalid => e
    redirect_to mock_attempt_path(mock_attempt),
      alert: e.record.errors.full_messages.join(", ")
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Unauthorized action"
  end
end
