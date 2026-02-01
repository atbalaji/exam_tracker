class AddMissingNullFalseToColumns < ActiveRecord::Migration[7.1]
  def change
    change_column_null :exams, :name, false
    change_column_null :sections, :name, false
    change_column_null :users, :email, false
    change_column_null :users, :password_digest, false
    change_column_null :mock_attempts, :attempted_on, false
    change_column_null :mock_section_results, :attempted, false
    change_column_null :mock_section_results, :correct, false
    change_column_null :questions, :content, false
    change_column_null :questions, :correct_option, false
  end
end
