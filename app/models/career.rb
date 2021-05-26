class Career < ApplicationRecord
  belongs_to :user, inverse_of: :careers, optional: true
  validates_length_of :title, maximum: 255
end
