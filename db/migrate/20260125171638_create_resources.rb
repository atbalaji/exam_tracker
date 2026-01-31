class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :url
      t.string :resource_type
      t.string :tags
      t.text :notes

      t.timestamps
    end
  end
end
