class Inquiry < ApplicationRecord
  include ActiveModel::Model

  attr_accessor :username, :telephone, :email, :title, :description
end
