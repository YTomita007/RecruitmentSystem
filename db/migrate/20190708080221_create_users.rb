class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :username, null: false
      t.integer :role, null: false
      t.string :remember_token
      t.boolean :administrator, default: false
      t.boolean :activate, default: true
      t.timestamps
    end
  end
end
