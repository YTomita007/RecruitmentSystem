class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.integer :number, null: false
      t.string :classification, null: false
      t.string :title, null: false
      t.string :description
      t.timestamps
    end
  end
end
