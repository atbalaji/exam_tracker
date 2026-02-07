class MockSectionResultsController < ApplicationController
  def create
    mock_attempt_id = params[:results].first[:mock_attempt_id]

    ActiveRecord::Base.transaction do
      params[:results].each do |result|
        next if result[:total_questions].blank? && result[:attempted].blank? && result[:correct].blank?

        mock_section_result = MockSectionResult.find_or_initialize_by(
          mock_attempt_id: result[:mock_attempt_id],
          section_id: result[:section_id],
        )

        mock_section_result.assign_attributes(
          total_questions: result[:total_questions],
          attempted: result[:attempted],
          correct: result[:correct]
        )

        unless msr.save
          raise ActiveRecord::Rollback, mock_section_result.errors.full_messages.join(", ")
        end
      end
    end


    redirect_to mock_attempt_path(mock_attempt_id), notice: "Section results saved"

    rescue => e
      redirect_to mock_attempt_path(mock_attempt_id), alert: e.message.presence || "Invalid section data"
  end
end
