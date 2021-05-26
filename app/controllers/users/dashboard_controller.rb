class Users::DashboardController < ApplicationController
  before_action :session_destroy

  def index
    num = 0
    @teammember = []
    @user = []
    @mate = []
    if @current_user.nil?
      redirect_to new_createteams_category_path
    elsif @current_user.role == 1
      @clientproject = Project.where(client_id: @current_user.id)
      @object = [[],[],[],[]]
      while num < @clientproject.size
        @team = Team.find(@clientproject.map(&:id))
        unless @team.blank?
          @teammember[num] = TeamMember.where(team_id: @team[num].id)
          @teammember[num].each_with_index do |index, i|
            if @teammember[num][i].user.picture.present?
              if Rails.env == 'production'
                @object[num][i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @teammember[num][i].user.picture.path
              else
                @object[num][i] = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @teammember[num][i].user.picture.path
              end
            end
          end
          @user[num] = User.find(@teammember[num].map(&:user_id))
        end
        num += 1
      end
    elsif @current_user.role == 2
      @team = Team.find(@current_user.team_members.map(&:team_id))
      @creatorproject = Project.find(@team.map(&:id))
      @object = [[],[],[],[]]
      while num < @creatorproject.size
        @team = Team.find(@creatorproject.map(&:id))
        unless @team.blank?
          @teammember[num] = TeamMember.where(team_id: @team[num].id)
          @teammember[num].each_with_index do |index, i|
            if @teammember[num][i].user.picture.present?
              if Rails.env == 'production'
                @object[num][i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @teammember[num][i].user.picture.path
              else
                @object[num][i] = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @teammember[num][i].user.picture.path
              end
            end
          end
          @user[num] = User.find(@teammember[num].map(&:user_id))
        end
        num += 1
      end
      @answer = TeamMember.where(user_id: @current_user.id)
    end
  end

  private

  def session_destroy
    session.delete(:createteam)
    session.delete(:agent)
    session.delete(:fromnew)
    session.delete(:fromlp)
    @percent = nil
  end
end
