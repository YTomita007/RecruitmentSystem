class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :personality
      t.integer :technically
      t.integer :quality
      t.integer :delivery
      t.integer :responsibility
      t.string :comment
      t.integer :client_id, null: false
      t.integer :project_id, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
