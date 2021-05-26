class CreatePaperclips < ActiveRecord::Migration[5.2]
  def change
    create_table :paperclips do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :link
      t.timestamps
    end
  end
end
