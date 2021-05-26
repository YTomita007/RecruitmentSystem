class CreateMemberSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :member_skills do |t|
      t.references :user, index: true, foreign_key: true
      t.references :skill, index: true, foreign_key: true
      t.string :title
      t.timestamps
    end
  end
end
