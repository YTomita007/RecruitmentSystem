class Admin::Users::CreatorsController < Admin::Base
  def index
    @creators = User.where(role: 2)
  end
end
