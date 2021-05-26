class Users::PortfolioController < ApplicationController
  before_action :checkid

  def edit
    @user = User.find(params[:id])
    @paperclip = Paperclip.find_by(user_id: @user.id)
    if @paperclip
      if @paperclip.image.present?
        if Rails.env == 'production'
          @portfolio = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.path
        else
          @portfolio = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.path
        end
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:user].present?
      if @user.update(paperclip_params)
        flash[:notice] = "ポートフォリオを更新しました"
        redirect_to users_setting_path
      else
        flash[:alert] = "ポートフォリオの更新に失敗しました"
        redirect_to users_setting_path
      end
    else
      redirect_to users_setting_path
    end
  end

  private

  def paperclip_params
    params.require(:user).permit(paperclip_attributes: [:id, :title, :image, :image_cache, :remove_image, :link, :_destroy])
  end

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
