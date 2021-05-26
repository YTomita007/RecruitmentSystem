class Users::TeammembersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if @user.picture.present?
      if Rails.env == 'production'
        @object = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      else
        @object = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      end
    end
    @detail = User.find(@user.id)
    @memberskills = MemberSkill.where(user_id: @user.id)
    @skill = Skill.find(@memberskills.map(&:skill_id))
    @career = @user.careers.build
    @paperclip = @user.paperclips.build
    @paperclips = Paperclip.where(user_id: @user.id)
  end

  def team
    @object = []
    @thumbnail = []
    @portfolio = []
    @teammembers = TeamMember.where(team_id: params[:id])
    @teammembers.each_with_index do |index, i|
      if @teammembers[i].user.picture.present?
        if Rails.env == 'production'
          @object[i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @teammembers[i].user.picture.path
        else
          @object[i] = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @teammembers[i].user.picture.path
        end
      end
    end
    @user = User.find(@teammembers.map(&:user_id))
    @memberskills = []
    @career = []
    if !MemberSkill.where(user_id: @user.map(&:id)).empty?
      @user.each_with_index do |index, i|
        @memberskills[i] = MemberSkill.where(user_id: @user[i].id)
        if @memberskills[i].nil?
          @memberskills[i] = [nil]
        end
      end
    end
    @user.each_with_index do |index, i|
      if @user[i].paperclip.present?
        if Rails.env == 'production'
          @portfolio[i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user[i].paperclip.image.path
        else
          @portfolio[i] = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user[i].paperclip.image.path
        end
      end
    end
    if !Career.where(user_id: @user.map(&:id)).empty?
      @user.each_with_index do |index, i|
        @career[i] = Career.where(user_id: @user[i].id)
        if @career[i].nil?
          @career[i] = [nil]
        end
      end
    end
  end
end
