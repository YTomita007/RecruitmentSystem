class AddPictureToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :english_name, :string
    add_column :users, :picture, :string
    add_column :users, :picture_url, :string
  end
end
