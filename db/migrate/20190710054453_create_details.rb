class CreateDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :details do |t|
      t.references :user, index: true, foreign_key: true
      t.string :telephone
      t.date :birthday
      t.integer :gender
      t.integer :character_id
      t.string :character_name
      t.string :company
      t.string :current_position
      t.string :address
      t.string :country
      t.string :languages
      t.string :introduction
      t.boolean :availability, default: true
      t.boolean :projectmanager, default: false
      t.boolean :webdesigner, default: false
      t.boolean :uiuxdesigner, default: false
      t.boolean :frontendengineer, default: false
      t.boolean :backendengineer, default: false
      t.integer :schedule
      t.integer :hourly_rate
      t.string :communication_tool
      t.string :website
      t.string :payment_address
      t.timestamps
    end
  end
end
