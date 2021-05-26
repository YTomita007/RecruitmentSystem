class Admin::Masters::MastersController < ApplicationController
  def index
    @skill = Skill.all
    @category = Category.all
  end
end
