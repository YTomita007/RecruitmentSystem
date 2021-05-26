class Team < ApplicationRecord
  belongs_to :project, inverse_of: :team, optional: true

  has_many :members, through: :team_members
  has_many :team_members, foreign_key: :team_id, dependent: :destroy
  accepts_nested_attributes_for :team_members, allow_destroy: true
  attr_accessor :users
end
