class Api::MemberSkillsController < ApplicationController
  def show
    @user = User.find(params[:id])
    @memberskills = MemberSkill.where(user_id: @user.id)
    render 'show', formats: 'json', handlers: 'jbuilder'
  end
end
