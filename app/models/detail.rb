class Detail < ApplicationRecord
  belongs_to :user, inverse_of: :detail, optional: true
end
