class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.references :team, index: true, foreign_key: true
      t.string :title, default: "プロジェクトA"
      t.integer :client_id
      t.string :description
      t.date :beginning
      t.date :ending
      t.integer :status, null: false
      t.timestamps
    end
  end
end
