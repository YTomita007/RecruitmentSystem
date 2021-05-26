class Users::SkillController < ApplicationController
  before_action :checkid

  def edit
    @user = User.find(params[:id])
    @memberskills = MemberSkill.where(user_id: @user.id)
    @skill = Skill.find(@memberskills.map(&:skill_id))
  end

  def update
    @user = User.find(params[:id])
    MemberSkill.where(user_id: @user.id).delete_all
    s = params[:user][:memberskills].values
    memberskills = s.sample.split(",")
    @skill = Skill.where(title: memberskills)
    @skill.each_with_index do |index, i|
        @user.member_skills.create(skill_id: @skill[i].id, title: @skill[i].title)
    end
    flash[:notice] = "スキルを登録しました"
    redirect_to users_setting_path
  end

  private

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
