class AddMarkingSchemeToExam < ActiveRecord::Migration[7.1]
  def change
    add_column :exams, :marks_per_correct, :float, null: false, default: 1.0
    add_column :exams, :negative_mark, :float, null: false, default: 0.0
  end
end
