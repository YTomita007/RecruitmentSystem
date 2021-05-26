class CreateCareers < ActiveRecord::Migration[5.2]
  def change
    create_table :careers do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :description
      t.date :start_duration
      t.date :end_duration
      t.timestamps
    end
  end
end
