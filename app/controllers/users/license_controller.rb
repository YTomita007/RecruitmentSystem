class Users::LicenseController < ApplicationController
  before_action :checkid

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user].present?
      if @user.update(license_params)
        flash[:notice] = "ライセンスを登録しました"
        redirect_to users_setting_path
      else
        flash[:alert] = "登録に失敗しました"
        redirect_to users_setting_path
      end
    else
      redirect_to users_setting_path
    end
  end

  private

  def license_params
    params.require(:user).permit(licenses_attributes: [:id, :title, :acquisition, :point, :_destroy])
  end

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
