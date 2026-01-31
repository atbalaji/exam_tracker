class CreateMockAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :mock_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exam, null: false, foreign_key: true
      t.date :attempted_on
      t.string :source
      t.text :notes

      t.timestamps
    end
  end
end
