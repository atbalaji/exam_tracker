class CreateQuizQuestionAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_question_attempts do |t|
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.string :selected_option
      t.boolean :is_correct
      t.integer :time_spent_seconds

      t.timestamps
    end
  end
end
