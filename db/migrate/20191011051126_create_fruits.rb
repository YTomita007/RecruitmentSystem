class CreateFruits < ActiveRecord::Migration[5.2]
  def change
    create_table :fruits do |t|
      t.string :ename, null: false
      t.string :wname, null: false
      t.string :animal, null: false
      t.string :group, null: false
      t.integer :cabbala, null: false
      t.string :description
      t.timestamps
    end
  end
end
