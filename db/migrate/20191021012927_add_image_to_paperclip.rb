class AddImageToPaperclip < ActiveRecord::Migration[5.2]
  def change
    add_column :paperclips, :image, :string
  end
end
