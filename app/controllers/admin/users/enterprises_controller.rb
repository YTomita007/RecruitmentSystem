class Admin::Users::EnterprisesController < Admin::Base
  def index
    @enterprises = User.where(role: 1)
  end
end
