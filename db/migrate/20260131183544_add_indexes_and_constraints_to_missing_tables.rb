class AddIndexesAndConstraintsToMissingTables < ActiveRecord::Migration[7.1]
  def change
    add_index :mock_attempts, :user_id unless index_exists?(:mock_attempts, :user_id)
    add_index :mock_attempts, :exam_id unless index_exists?(:mock_attempts, :exam_id)

    add_index :sections, :exam_id unless index_exists?(:sections, :exam_id)
    add_index :mock_section_results, :mock_attempt_id unless index_exists?(:mock_section_results, :mock_attempt_id)
    add_index :mock_section_results, :section_id unless index_exists?(:mock_section_results, :section_id)

    add_index :users, :email, unique: true unless index_exists?(:users, :email)
    add_index :exams, :name, unique: true unless index_exists?(:exams, :name)

    add_index :sections, [:exam_id, :name], unique: true unless index_exists?(:sections, [:exam_id, :name])
    add_index :mock_section_results, [:mock_attempt_id, :section_id], unique: true unless index_exists?(:mock_section_results, [:mock_attempt_id, :section_id])
  end
end
