class CreateLicenses < ActiveRecord::Migration[5.2]
  def change
    create_table :licenses do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.date :acquisition
      t.integer :point
      t.timestamps
    end
  end
end
