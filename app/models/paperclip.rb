class Paperclip < ApplicationRecord
  belongs_to :user, inverse_of: :paperclip, optional: true

  mount_uploader :image, ImageUploader

  has_one_attached :portfolio_data
  attribute :new_portfolio_data

  before_save do
    self.portfolio_data = new_portfolio_data if new_portfolio_data
  end
end
