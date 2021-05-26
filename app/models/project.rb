class Project < ApplicationRecord
  belongs_to :team, inverse_of: :project, optional: true
  accepts_nested_attributes_for :team
  validates_length_of :title, maximum: 255
end
