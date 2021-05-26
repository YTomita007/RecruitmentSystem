class Admin::Organizations::TeamsController < Admin::Base
  def index
    @team = Team.all
    @project = Project.find(@team.map(&:id))
    @client = []
    @project.each_with_index do |index, i|
      @client[i] = User.find_by(id: @project[i].client_id)
      if @client[i].nil?
        @client[i] = []
      end
    end
  end

  def edit
    @team = Team.find(params[:id])
    @project = Project.find_by(team_id: @team.id)
  end

  def show
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
          # @thumbnail[i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user[i].paperclip.image.versions[:web_thumb].path
          @portfolio[i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user[i].paperclip.image.path
        else
          # @thumbnail[i] = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user[i].paperclip.image.versions[:web_thumb].path
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

  def update
    @project = Project.find_by(team_id: params[:project][:id])
    if params[:project][:status] == "1"
      if @project.update(team_update_params)
        flash.alert =  "プロジェクトの状態を更新しました。"
        render :edit
      else
        flash.alert =  "プロジェクトの状態の更新に失敗しました。"
        render :edit
      end
    else
      if @project.update(status_params)
        flash.alert =  "プロジェクトの状態を更新しました。"
        render :edit
      else
        flash.alert =  "プロジェクトの状態の更新に失敗しました。"
        render :edit
      end
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @project = Project.find_by(team_id: @team.id)
    @teammembers = TeamMember.where(team_id: params[:id])
    @teammembers.each_with_index do |index, i|
      @teammembers[i].destroy
    end
    @project.destroy
    @team.destroy
    redirect_to admin_organizations_teams_path
  end

  private

    def status_params
      params.require(:project).permit(:id, :title, :status, :beginning)
    end

    def team_update_params
      status_params.merge(beginning: Time.current )
    end
end
