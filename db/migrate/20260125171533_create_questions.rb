class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :section, null: false, foreign_key: true
      t.string :topic
      t.string :difficulty
      t.text :content
      t.string :option_a
      t.string :option_b
      t.string :option_c
      t.string :option_d
      t.string :correct_option
      t.integer :created_by_id

      t.timestamps
    end
  end
end
