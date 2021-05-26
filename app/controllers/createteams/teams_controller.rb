class Createteams::TeamsController < ApplicationController
  before_action :set_team_members, only: [:create]
  protect_from_forgery except: [:create, :destroy]

  def new
    @team = Team.new
    @team.build_project
    @team.team_members.build
  end

  def create
    if params[:team][:id] == "0"
      redirect_to consult_new_general_inquiry_path
    else
      if params[:team][:id] == "80"
        session[:budget] = 800000
      elsif params[:team][:id] == "110"
        session[:budget] = 1100000
      elsif params[:team][:id] == "150"
        session[:budget] = 1500000
      elsif params[:team][:id] == "180"
        session[:budget] = 1800000
      elsif params[:team][:id] == "250"
        session[:budget] = 2500000
      end
      @team = Team.new(genre: session[:category], urgency: session[:urgency], budget: session[:budget], frequency: session[:frequency])
      if @team.save
        team_id = Team.find(@team.id)
        if @current_user
          @project = Project.new(team_id: team_id.id, status: 1, client_id: @current_user.id)
        else
          @project = Project.new(team_id: team_id.id, status: 1)
        end
        @project.save
        session[:team_id] = team_id.id
        @user.each_with_index do |index, i|
          team_id.team_members.create(user_id: @user[i].id, position: i+1)
        end
        redirect_to result_createteams_teams_path
      else
        redirect_to error_createteams_teams_path
      end
    end
  end

  def result
    @object = [[],[],[],[]]
    @team = Team.find(session[:team_id])
    @teammember = TeamMember.where(team_id: session[:team_id])
    @teammember.each_with_index do |index, i|
      if @teammember[i].user.picture.present?
        if Rails.env == 'production'
          @object[i] = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @teammember[i].user.picture.path
        else
          @object[i] = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @teammember[i].user.picture.path
        end
      end
    end
    @user = User.new
    @user.build_detail
  end

  def destroy
    session.delete(:createteam)
    session.delete(:category)
    session.delete(:urgency)
    session.delete(:budget)
    session.delete(:frequency)
    @team = Team.find(session[:team_id])
    @project = Project.find(@team.id)
    @project.destroy
    @team.destroy
    session.delete(:team_id)
    redirect_to root_path
  end

  def sendmail
    @project = Project.find(session[:team_id])
    begin
      @project.update(client_id: @current_user.id)
      begin
        #本運用時にはコメントアウトを解除して運営側に通知されるように設定する 2019/10/11解除
        if Rails.env == 'production'
          AnnouncementMailer.team_request_message(@current_user.email).deliver_now
          NotificationMailer.team_success_message(@current_user.email).deliver_now
        else
          NotificationMailer.team_success_message(@current_user.email).deliver_now
        end
        flash[:notice] = "無料相談の旨を運営事務局へ通達しました"
        session.delete(:team_id)
      rescue
        flash.alert = "登録したメールアドレスは存在しません"
      end
    rescue
      flash.alert = "致命的な障害が発生しました。システム管理者へ連絡してください"
    end
    redirect_to reservation_createteams_teams_path
  end

  def reservation
    session.delete(:createteam)
    session.delete(:category)
    session.delete(:urgency)
    session.delete(:budget)
    session.delete(:frequency)
    session.delete(:team_id)
#    スラック対応のために取っておく。
#    HTTParty.get("https://slack.com/api/users.admin.invite?token=xoxp-569448662931-568996458881-704858737825-d8df9c774174015dd85ae292caa4123f&email=" + @current_user.email + "&channels=CGRFHTHGU")
  end

  private

  def set_team_members
    i = 0
    numbers = [1, 2, 3]
    if params[:team][:id] == "80"
      #@projectmanager = Detail.where("schedule <= '16' and projectmanager = '1' and availability = '1'").sample
      @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
      loop do
        @designer = Detail.new
        #@designer = Detail.where("(schedule <= '16' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
        @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
        i += 1
        break if i > 15
        break if @projectmanager != @designer && @designer != @current_user
      end
      loop do
        @engineer = Detail.new
        #@engineer = Detail.where("(schedule <= '16' and availability = '1') and frontendengineer = '1' or backendengineer = '1'").sample
        @engineer = Detail.where("availability = '1' and frontendengineer = '1' or backendengineer = '1'").sample
        i += 1
        break if i > 15
        break if @engineer != @projectmanager && @engineer != @designer && @engineer != @current_user
      end
      session[:frequency] = 2
      @detail = [@projectmanager, @designer, @engineer]
    elsif params[:team][:id] == "110"
      patern = numbers.sample
      if patern == 1
        #@projectmanager = Detail.where("schedule <= '24' and projectmanager = '1' and availability = '1'").sample
        @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
        loop do
          @designer = Detail.new
          #@designer = Detail.where("(schedule <= '24' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
          @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
          i += 1
          break if i > 15
          break if @projectmanager != @designer and @designer != @current_user
        end
        loop do
          @engineer = Detail.new
          #@engineer = Detail.where("(schedule <= '24' and availability = '1') and frontendengineer = '1' or backendengineer = '1'").sample
          @engineer = Detail.where("availability = '1' and frontendengineer = '1' or backendengineer = '1'").sample
          i += 1
          break if i > 15
          break if @engineer != @projectmanager and @engineer != @designer and @engineer != @current_user
        end
        session[:frequency] = 3
        @detail = [@projectmanager, @designer, @engineer]
      else
        #@projectmanager = Detail.where("schedule <= '16' and projectmanager = '1' and availability = '1'").sample
        @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
        loop do
          @designer = Detail.new
          #@designer = Detail.where("(schedule <= '16' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
          @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
          i += 1
          break if i > 15
          break if @projectmanager != @designer && @designer != @current_user
        end
        loop do
          @frontendengineer = Detail.new
          #@frontendengineer = Detail.where("(schedule <= '16' and availability = '1') and frontendengineer = '1'").sample
          @frontendengineer = Detail.where("availability = '1' and frontendengineer = '1'").sample
          i += 1
          break if i > 15
          break if @frontendengineer != @projectmanager && @frontendengineer != @designer && @frontendengineer != @current_user
        end
        loop do
          @backendengineer = Detail.new
          #@backendengineer = Detail.where("schedule <= '16' and backendengineer = '1' and availability = '1'").sample
          @backendengineer = Detail.where("backendengineer = '1' and availability = '1'").sample
          i += 1
          break if i > 15
          break if @backendengineer != @projectmanager && @backendengineer != @designer && @backendengineer != @frontendengineer && @backendengineer != @current_user
        end
        session[:frequency] = 2
        @detail = [@projectmanager, @designer, @frontendengineer, @backendengineer]
      end
    elsif params[:team][:id] == "150"
      patern = numbers.sample
      if patern == 1
        #@projectmanager = Detail.where("schedule <= '32' and projectmanager = '1' and availability = '1'").sample
        @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
        loop do
          @designer = Detail.new
          #@designer = Detail.where("(schedule <= '32' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
          @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
          i += 1
          break if i > 15
          break if @projectmanager != @designer and @designer != @current_user
        end
        loop do
          @engineer = Detail.new
          #@engineer = Detail.where("(schedule <= '32' and availability = '1') and frontendengineer = '1' or backendengineer = '1'").sample
          @engineer = Detail.where("availability = '1' and frontendengineer = '1' or backendengineer = '1'").sample
          i += 1
          break if i > 15
          break if @engineer != @projectmanager and @engineer != @designer and @engineer != @current_user
        end
        session[:frequency] = 4
        @detail = [@projectmanager, @designer, @engineer]
      else
        #@projectmanager = Detail.where("schedule <= '24' and projectmanager = '1' and availability = '1'").sample
        @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
        loop do
          @designer = Detail.new
          #@designer = Detail.where("(schedule <= '24' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
          @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
          i += 1
          break if i > 15
          break if @projectmanager != @designer && @designer != @current_user
        end
        loop do
          @frontendengineer = Detail.new
          #@frontendengineer = Detail.where("(schedule <= '24' and availability = '1') and frontendengineer = '1'").sample
          @frontendengineer = Detail.where("availability = '1' and frontendengineer = '1'").sample
          i += 1
          break if i > 15
          break if @frontendengineer != @projectmanager && @frontendengineer != @designer && @frontendengineer != @current_user
        end
        loop do
          @backendengineer = Detail.new
          #@backendengineer = Detail.where("(schedule <= '24' and availability = '1') and backendengineer = '1'").sample
          @backendengineer = Detail.where("backendengineer = '1' and availability = '1'").sample
          i += 1
          break if i > 15
          break if @backendengineer != @projectmanager && @backendengineer != @designer && @backendengineer != @frontendengineer && @backendengineer != @current_user
        end
        session[:frequency] = 3
        @detail = [@projectmanager, @designer, @frontendengineer, @backendengineer]
      end
    elsif params[:team][:id] == "180"
      patern = numbers.sample
      if patern == 1
        #@projectmanager = Detail.where("schedule <= '40' and projectmanager = '1' and availability = '1'").sample
        @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
        loop do
          @designer = Detail.new
          #@designer = Detail.where("(schedule <= '40' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
          @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
          i += 1
          break if i > 15
          break if @projectmanager != @designer and @designer != @current_user
        end
        loop do
          @engineer = Detail.new
          #@engineer = Detail.where("(schedule <= '40' and availability = '1') and frontendengineer = '1' or backendengineer = '1'").sample
          @engineer = Detail.where("availability = '1' and frontendengineer = '1' or backendengineer = '1'").sample
          i += 1
          break if i > 15
          break if @engineer != @projectmanager and @engineer != @designer and @engineer != @current_user
        end
        session[:frequency] = 5
        @detail = [@projectmanager, @designer, @engineer]
      else
        #@projectmanager = Detail.where("schedule <= '32' and projectmanager = '1' and availability = '1'").sample
        @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
        loop do
          @designer = Detail.new
          #@designer = Detail.where("(schedule <= '32' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
          @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
          i += 1
          break if i > 15
          break if @projectmanager != @designer && @designer != @current_user
        end
        loop do
          @frontendengineer = Detail.new
          #@frontendengineer = Detail.where("(schedule <= '32' and availability = '1') and frontendengineer = '1'").sample
          @frontendengineer = Detail.where("availability = '1' and frontendengineer = '1'").sample
          i += 1
          break if i > 15
          break if @frontendengineer != @projectmanager && @frontendengineer != @designer && @frontendengineer != @current_user
        end
        loop do
          @backendengineer = Detail.new
          #@backendengineer = Detail.where("(schedule <= '32' and availability = '1') and backendengineer = '1'").sample
          @backendengineer = Detail.where("backendengineer = '1' and availability = '1'").sample
          i += 1
          break if i > 15
          break if @backendengineer != @projectmanager && @backendengineer != @designer && @backendengineer != @frontendengineer && @backendengineer != @current_user
        end
        session[:frequency] = 4
        @detail = [@projectmanager, @designer, @frontendengineer, @backendengineer]
      end
    elsif params[:team][:id] == "250"
      #@projectmanager = Detail.where("schedule <= '40' and projectmanager = '1' and availability = '1'").sample
      @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
      loop do
        @designer = Detail.new
        #@designer = Detail.where("(schedule <= '40' and availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
        @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
        i += 1
        break if i > 15
        break if @projectmanager != @designer && @designer != @current_user
      end
      loop do
        @frontendengineer = Detail.new
        #@frontendengineer = Detail.where("(schedule <= '40' and availability = '1') and frontendengineer = '1'").sample
        @frontendengineer = Detail.where("availability = '1' and frontendengineer = '1'").sample
        i += 1
        break if i > 15
        break if @frontendengineer != @projectmanager && @frontendengineer != @designer && @frontendengineer != @current_user
      end
      loop do
        @backendengineer = Detail.new
        #@backendengineer = Detail.where("(schedule <= '40' and availability = '1') and backendengineer = '1'").sample
        @backendengineer = Detail.where("backendengineer = '1' and availability = '1'").sample
        i += 1
        break if i > 15
        break if @backendengineer != @projectmanager && @backendengineer != @designer && @backendengineer != @frontendengineer && @backendengineer != @current_user
      end
      session[:frequency] = 5
      @detail = [@projectmanager, @designer, @frontendengineer, @backendengineer]
    else
      #@projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
      @projectmanager = Detail.where("projectmanager = '1' and availability = '1'").sample
      loop do
        @designer = Detail.new
        #@designer = Detail.where("(availability = '1') and webdesigner = '1' or uiuxdesigner = '1'").sample
        @designer = Detail.where("availability = '1' and webdesigner = '1' or uiuxdesigner = '1'").sample
        i += 1
        break if i > 15
        break if @projectmanager != @designer && @designer != @current_user
      end
      loop do
        @frontendengineer = Detail.new
        #@frontendengineer = Detail.where("frontendengineer = '1' and availability = '1'").sample
        @frontendengineer = Detail.where("availability = '1' and frontendengineer = '1'").sample
        i += 1
        break if i > 15
        break if @frontendengineer != @projectmanager && @frontendengineer != @designer && @frontendengineer != @current_user
      end
      loop do
        @backendengineer = Detail.new
        #@backendengineer = Detail.where("backendengineer = '1' and availability = '1'").sample
        @backendengineer = Detail.where("backendengineer = '1' and availability = '1'").sample
        i += 1
        break if i > 15
        break if @backendengineer != @projectmanager && @backendengineer != @designer && @backendengineer != @frontendengineer && @backendengineer != @current_user
      end
      session[:frequency] = 5
      @detail = [@projectmanager, @designer, @frontendengineer, @backendengineer]
    end
    @detail.each_with_index do |index, i|
      @member = Detail.new
      @member = @detail[i]
      break if @member.nil?
    end
    if i > 15
      flash.alert = "検索条件に一致するチームが作成できませんでした。"
      redirect_to budget_createteams_categories_path(params[:team][:id])
    elsif @detail.nil?
      flash.alert = "検索条件に一致するチームが作成できませんでした。"
      redirect_to budget_createteams_categories_path(params[:team][:id])
    elsif @member.nil?
      flash.alert = "検索条件に一致するチームが作成できませんでした。"
      redirect_to budget_createteams_categories_path(params[:team][:id])
    else
      session[:createteam] = 9
      users = User.find(@detail.map(&:id))
      @user = users.select{|user| user.activate != false}
    end
  end
end
