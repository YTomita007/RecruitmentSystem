class AddFruitspicToFruits < ActiveRecord::Migration[5.2]
  def change
    add_column :fruits, :fruitspic, :string
    add_column :fruits, :animalpic, :string
    add_column :details, :level, :integer
    add_column :details, :participants, :integer
    add_column :careers, :occupation, :string
  end
end
