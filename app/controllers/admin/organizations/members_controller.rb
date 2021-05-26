class Admin::Organizations::MembersController < Admin::Base
  def index
    @team = Team.find_by(id: params[:team_id])
    @teammembers = TeamMember.where(team_id: params[:team_id])
  end

  def new
    @user = User.all
    @teammembers = TeamMember.find_by(team_id: params[:team_id])
  end

  def create
    @user = User.where(id: params[:team_member][:user_ids])
    @teammembers = TeamMember.where(team_id: params[:team_id])
    team_id = Team.find(params[:team_id])
    @user.each_with_index do |index, i|
      team_id.team_members.create(user_id: @user[i].id, position: @teammembers.length + i + 1)
    end
    redirect_to admin_organizations_team_members_path
  end

  def destroy
    @teammembers = TeamMember.where(team_id: params[:team_id]).where(user_id: params[:id])
    @teammembers[0].destroy
    redirect_to admin_organizations_team_members_path
  end

  private

  def team_members_params
    params.require(:user).permit(:id, user_ids: [])
  end
end
