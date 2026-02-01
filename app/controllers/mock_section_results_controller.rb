class MockSectionResultsController < ApplicationController
  def create
    params[:results].each do |result|
      next if result[:total_questions].blank? && result[:attempted].blank? && result[:correct].blank?

      mock_section_result = MockSectionResult.find_or_initialize_by(
        mock_attempt_id: result[:mock_attempt_id],
        section_id: result[:section_id],
      )

      mock_section_result.attempted = result[:attempted]
      mock_section_result.correct = result[:correct]

      mock_section_result.save!
    end

    redirect_to mock_attempt_path(params[:results].first[:mock_attempt_id])
  end
end
