class Createteams::CategoriesController < ApplicationController
  def new
    session.delete(:createteam)
    session.delete(:category)
    session.delete(:urgency)
    session.delete(:budget)
    session.delete(:frequency)
    session.delete(:team_id)
  end

  def vision
    if @current_user
      if @current_user.role != 1
        redirect_to root_path
      end
    end
    @category = Category.new
    session[:createteam] = 1
    @percent = session[:createteam]
  end

  def index
    if session[:createteam] == 5
      @category = Category.new
      session[:createteam] = 3
      @percent = session[:createteam]
    else
      if params[:category][:id] == "1"
        @category = Category.new
        session[:createteam] = 3
        @percent = session[:createteam]
      else
        redirect_to consult_new_general_inquiry_path
      end
    end
  end

  def show
    @subcategory = Category.new
    if session[:createteam] == 7
      num = Category.where(title: session[:category])
      @category = Category.where(number: num[0].number)
    else
      if params[:category][:id] == "1"
        @category = Category.where(number: 1)
      elsif params[:category][:id] == "2"
        @category = Category.where(number: 2)
      elsif params[:category][:id] == "3"
        @category = Category.where(number: 3)
      elsif params[:category][:id] == "4"
        @category = Category.where(number: 4)
      elsif params[:category][:id] == "9"
        redirect_to consult_new_general_inquiry_path
      else
        @category = Category.all
      end
    end
    session[:createteam] = 5
    @percent = session[:createteam]
  end

  # 旧urgency関数
  def budget
    @team = Team.new
    if session[:createteam] == 5
      if params[:category][:id] == "0"
        redirect_to consult_new_general_inquiry_path
      else
        classification = Category.find(params[:category][:id])
        session[:category] = classification.title
      end
    elsif session[:createteam] == 9
      @team = Team.find(session[:team_id])
      @project = Project.find(@team.id)
      @project.destroy
      @team.destroy
      session.delete(:team_id)
    end
    @subcategory = Category.new
    session[:createteam] = 7
    @percent = session[:createteam]
  end

# 旧budget関数
  def urgency
    unless session[:createteam] == 5
      @subcategory = Category.new
      if params[:category][:id] == "1"
        session[:urgency] = "0"
      elsif params[:category][:id] == "2"
        session[:urgency] = "0"
      elsif params[:category][:id] == "3"
        session[:urgency] = "0"
      elsif params[:category][:id] == "4"
        session[:urgency] = "1"
      else
        session[:urgency] = "unknown"
      end
    end
    @subcategory = Category.new
    session[:createteam] = 4
    @percent = session[:createteam]
  end

  def frequency
    @team = Team.new
    if params[:category][:id] == "80"
      session[:budget] = 800000
    elsif params[:category][:id] == "100"
      session[:budget] = 1000000
    elsif params[:category][:id] == "150"
      session[:budget] = 1500000
    else
      session[:budget] = 2000000
    end
    session[:createteam] = 7
    @percent = session[:createteam]
  end
end
