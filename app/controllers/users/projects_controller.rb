class Users::ProjectsController < ApplicationController
  protect_from_forgery except: [:update]

  def show
    @team = Team.find(params[:id])
    @project = Project.find(@team.id)
    @client = User.find_by(id: @project.client_id)
  end

  def edit
    @project = Project.find(params[:id])
    @client = User.find_by(id: @project.client_id)
    @team = Team.find(@project.id)
  end

  def update
    @team = Team.find(params[:id])
    @project = Project.find(@team.id)
    @teammember = TeamMember.find_by(team_id: @project.team_id, user_id: @current_user.id)
    if params[:project][:asnwer] == '1'
      flash.alert =  @project.title + "の回答を「参加する」で受付しました"
      @teammember.update(answer: 1)
      redirect_to root_path
    elsif params[:project][:asnwer] == '2'
      flash.alert =  @project.title + "の回答を「興味あり」で受付しました"
      @teammember.update(answer: 2)
      AnnouncementMailer.creator_interested_message(@teammember.user.email, @project.id).deliver_now
      redirect_to root_path
    elsif params[:project][:asnwer] == '3'
      flash.alert =  @project.title + "の回答を「辞退する」で受付しました"
      @teammember.update(answer: 3)
      redirect_to root_path
    elsif params[:commit] == '更新する'
      params[:project][:beginning] = beginning_join
      @project.update(project_params)
#      @team.update(team_params)
      redirect_to users_project_path
    end
  end

  def project_params
    params.require(:project).permit(:id, :title, :client_id, :beginning, :description, :status, team_attributes: [:id, :frequency])
  end

  def beginning_join
    date = params[:beginning]

    if date["beginning(1i)"].empty? && date["beginning(2i)"].empty? && date["beginning(3i)"].empty?
      return
    end

    Date.new date["beginning(1i)"].to_i, date["beginning(2i)"].to_i, date["beginning(3i)"].to_i
  end
end
