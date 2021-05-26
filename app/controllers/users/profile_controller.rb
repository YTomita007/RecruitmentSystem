class Users::ProfileController < ApplicationController
  before_action :checkid

  def edit
    @user = User.find(params[:id])
    if @user.picture.present?
      if Rails.env == 'production'
        @object = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      else
        @object = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      end
    end
    @detail = Detail.find(@user.id)
  end

  private

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
