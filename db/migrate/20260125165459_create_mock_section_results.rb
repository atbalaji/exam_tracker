class CreateMockSectionResults < ActiveRecord::Migration[7.1]
  def change
    create_table :mock_section_results do |t|
      t.references :mock_attempt, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.integer :attempted
      t.integer :correct
      t.integer :time_spent_minutes

      t.timestamps
    end
  end
end
