class CreateTeamMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :team_members do |t|
      t.references :user, index: true, foreign_key: true
      t.references :team, index: true, foreign_key: true
      t.integer :position
      t.integer :permission
      t.integer :answer
      t.timestamps
    end
  end
end
