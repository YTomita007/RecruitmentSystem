class Users::AvailabilityController < ApplicationController
  before_action :checkid

  def edit
    @user = User.find(params[:id])
    @detail = Detail.find(@user.id)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(availability_params)
      flash[:notice] = "稼働状況を更新しました"
      redirect_to users_setting_path
    else
      flash[:alert] = "稼働状況の更新に失敗しました"
      redirect_to edit_users_setting_path
    end
  end

  private

  def availability_params
    params.require(:user).permit(detail_attributes: [:id, :availability, :schedule, :hourly_rate])
  end

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
