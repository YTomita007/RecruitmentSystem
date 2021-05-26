class ChangeDataIntroductionToDetail < ActiveRecord::Migration[5.2]
  def change
    change_column :details, :introduction, :text
    change_column :categories, :description, :text
    change_column :careers, :description, :text
    change_column :projects, :description, :text
    change_column :assessments, :comment, :text
  end
end
