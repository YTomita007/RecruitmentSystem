class License < ApplicationRecord
  belongs_to :user, inverse_of: :licenses, optional: true
  validates_length_of :title, maximum: 255
end
