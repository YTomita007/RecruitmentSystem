class Admin::Masters::SkillsController < ApplicationController
  def index
    @skill = Skill.all
  end

  def new
    @skill = Skill.new
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def create
    if @skill = Skill.find_by(title: params[:skill][:title])
      flash.alert =  "入力したスキル名は既に登録されています。"
      render :new
    else
      @skill = Skill.new(skill_params)
      if @skill.save
        flash.alert =  "スキル登録に成功しました。"
        redirect_to admin_masters_skills_path
      else
        flash.alert =  "スキル登録に失敗しました。"
        render :new
      end
    end
  end

  def update
    @skill = Skill.find(params[:id])
    if @skill.update(skill_params)
      flash.alert =  "スキル更新に成功しました。"
      redirect_to admin_masters_skills_path
    else
      flash.alert =  "スキル更新に失敗しました。"
      render :new
    end
  end

  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy
    redirect_to admin_masters_skills_path
  end

  private

  def skill_params
    params.require(:skill).permit(:id, :title)
  end
end
