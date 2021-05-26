class Users::CurriculumController < ApplicationController
  before_action :checkid

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user].present?
      if @user.update(career_params)
        flash[:notice] = "メンバー情報を更新しました"
        redirect_to users_setting_path
      else
        flash[:alert] = "更新に失敗しました"
        redirect_to edit_users_setting_path
      end
    else
      redirect_to users_setting_path
    end
  end

  private

  def career_params
    params.require(:user).permit(careers_attributes: [:id, :title, :description, :start_duration, :end_duration, :_destroy])
  end

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
