class CreateSections < ActiveRecord::Migration[7.1]
  def change
    create_table :sections do |t|
      t.references :exam, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
