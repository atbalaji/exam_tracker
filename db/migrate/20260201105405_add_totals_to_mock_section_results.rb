class AddTotalsToMockSectionResults < ActiveRecord::Migration[7.1]
  def up
    # Add the column without NOT NULL
    add_column :mock_section_results, :total_questions, :integer

    # Backfill using attempted
    MockSectionResult.reset_column_information
    MockSectionResult.find_each do |msr|
      msr.update_column(:total_questions, msr.attempted)
    end

    # Add NOT NULL constraint
    change_column_null :mock_section_results, :total_questions, false
  end

  def down
    remove_column :mock_section_results, :total_questions
  end
end
