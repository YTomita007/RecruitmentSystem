class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :genre, null: false
      t.integer :budget, null: false
      t.string :urgency, default: 0
      t.integer :frequency, default: 2
      t.timestamps
    end
  end
end
