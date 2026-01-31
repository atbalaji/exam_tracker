class CreateQuizAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :section, null: false, foreign_key: true
      t.string :mode
      t.boolean :timed
      t.datetime :started_at
      t.datetime :ended_at

      t.timestamps
    end
  end
end
