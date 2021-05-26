class Users::SettingsController < ApplicationController
  before_action :checkid

  def show
    @user = User.find(params[:id])
    if @user.picture.present?
      if Rails.env == 'production'
        @object = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      else
        @object = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      end
    end
    @detail = Detail.find(@user.id)
    @memberskills = MemberSkill.where(user_id: @user.id)
    @skill = Skill.find(@memberskills.map(&:skill_id))
    @career = Career.where(user_id: @user.id)
    @paperclip = Paperclip.find_by(user_id: @user.id)
    @license = License.where(user_id: @user.id)
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
    @memberskills = MemberSkill.where(user_id: @user.id)
    @skill = Skill.find(@memberskills.map(&:skill_id))
    @paperclip = Paperclip.find_by(user_id: @user.id)
    if @paperclip.present?
      if Rails.env == 'production'
        @portfolio = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.path
      else
        @portfolio = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.path
      end
    end
  end

  private

  def checkid
    @user = User.find(params[:id])
    if @current_user.id != @user.id
      raise Forbidden
    end
  end
end
