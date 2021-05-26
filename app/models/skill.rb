class Skill < ApplicationRecord
  has_many :member_skills
  has_many :users, through: :member_skills
end
