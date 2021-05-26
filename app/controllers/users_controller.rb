class UsersController < ApplicationController
  require "open-uri"

  protect_from_forgery except: [:create, :update]
  before_action :fruits_character_set, only: [:update]

  def auth_callback
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user
      url = request.env["omniauth.auth"].info.image.to_s
      save_image(url.gsub('http://','https://'))
      @user.picture = Rack::Test::UploadedFile.new("#{Rails.root}/tmp/profile.jpg",'image/jpeg')
      result = @user.save
      if result
        sign_in @user
        redirect_to passwordupdate_users_path(@user.id)
        if Rails.env == 'production'
          if @user.role == 1
            NotificationMailer.registration_enterprise_message(@user.email).deliver_now
            AnnouncementMailer.sns_registration_message(@user.email).deliver_now
          else
            NotificationMailer.registration_creator_message(@user.email).deliver_now
            AnnouncementMailer.sns_registration_message(@user.email).deliver_now
          end
        end
      else
        redirect_to auth_failure_path
      end
    else
      @user = User.find_by(email: request.env["omniauth.auth"].info.email)
      sign_in @user
      flash.alert =  "すでに登録されています。"
      redirect_to root_path
    end
  end

  def auth_failure
    @user = User.new
    flash.alert =  "Facebook認証が失敗しました"
    redirect_to root_path
  end

  def passwordupdate
    @user = User.find(@current_user.id)
  end

  def save_image(url)
    fileName = "profile.jpg"
    dirName = "#{Rails.root}/tmp/"
    filePath = dirName + fileName

    # write image adata
    open(filePath, 'wb') do |output|
      open(url) do |data|
        output.write(data.read)
      end
    end
  end

  def step1
    if session[:fromlp].present?
      @user = User.new
      @user.build_detail
      session.delete(:fromlp)
    elsif session[:fromnew].present?
      @user = User.new(current_status)
      session.delete(:fromnew)
    else
      @user = User.new
      @user.build_detail
    end
  end

  def step2
    if @user = User.find_by(email: params[:user][:email])
      flash.alert =  "入力したメールアドレスは既に登録されています"
     redirect_to step1_new_user_path, status: 302
    else
      @user = User.new(current_status)
      session[:fromnew] = true
    end
  end

  def creators
    if session[:fromlp].nil?
      @user = User.new
      @user.build_detail
    else
      @user = User.new(current_status)
    end
  end

  def enterprise
    if session[:fromlp].nil?
      @user = User.new
      @user.build_detail
    else
      @user = User.new(current_status)
    end
  end

  def confirmation
    if @user = User.find_by(email: params[:user][:email])
      flash.alert =  "入力したメールアドレスは既に登録されています"
      if params[:user][:role] == "1"
        redirect_to enterprise_new_user_path
      else
        redirect_to creators_new_user_path
      end
    else
      @user = User.new(current_status)
      session[:fromlp] = true
    end
  end

  def create
    if session[:team_id].nil?
      @user = User.new(user_params)
      if @user.save
        sign_in(@user)
        flash.alert =  "メンバー登録が完了しました"
        if Rails.env == 'production'
          if @user.role == 1
            NotificationMailer.registration_enterprise_message(@user.email).deliver_now
            AnnouncementMailer.registration_enterprise_message(@user.email).deliver_now
          else
            NotificationMailer.registration_creator_message(@user.email).deliver_now
            AnnouncementMailer.registration_creator_message(@user.email).deliver_now
          end
        else
          if @user.role == 1
            NotificationMailer.registration_enterprise_message(@user.email).deliver_now
          else
            NotificationMailer.registration_creator_message(@user.email).deliver_now
          end
        end
        redirect_to root_path
      else
        flash.alert =  "メンバー登録に失敗しました"
        redirect_to step2_new_user_path
      end
    else
      if @user = User.find_by(email: params[:user][:email])
        flash.alert =  "入力したメールアドレスは既に登録されています"
        render result_createteams_teams_path
      else
        @user = User.new(javascript_params)
        if @user.save
          sign_in(@user)
          if Rails.env == 'production'
            if @user.role == 1
              NotificationMailer.registration_enterprise_message(@user.email).deliver_now
              AnnouncementMailer.registration_enterprise_message(@user.email).deliver_now
            else
              NotificationMailer.registration_creator_message(@user.email).deliver_now
              AnnouncementMailer.registration_creator_message(@user.email).deliver_now
            end
          else
            if @user.role == 1
              NotificationMailer.registration_enterprise_message(@user.email).deliver_now
            else
              NotificationMailer.registration_creator_message(@user.email).deliver_now
            end
          end
          redirect_to sendmail_createteams_teams_path
        else
          flash.alert =  "メンバー登録に失敗しました"
          render :result
        end
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if params[:commit] == '更新する'
      params[:user][:detail_attributes][:birthday] = birthday_join
      if @user.update(user_params)
        if @user.picture.present?
          update_picture_url
        end
        flash[:notice] = "メンバー情報を更新しました"
        redirect_to users_setting_path
      else
        flash[:alert] = "更新に失敗しました"
        redirect_to users_setting_path
      end
    elsif params[:commit] == 'パスワード更新'
      if @current_user
        @user = User.find(@current_user.id)
      else
        @user = User.find_by(email: params[:user][:email])
      end
      if @user.update(resetpassword_params)
        if session[:resetpassword] == "ResetPassword"
          sign_in(@user)
          session.delete(:resetpassword)
        end
        flash.alert =  "メンバー情報を更新しました"
        redirect_to :root
      end
    end
  end

  def change
    if @current_user.role == 1
      @current_user.update(role: 2)
      flash.alert = "アカウントを受注者用に変更しました"
    else
      @current_user.update(role: 1)
      flash.alert = "アカウントを発注者用に変更しました"
    end
    redirect_to :root
  end

  private

  def set_first_params
    params.require(:user).permit(:lastname, :firstname, :eng_lastname, :eng_firstname, :email, :role, :password,
      detail_attributes: [:telephone, :company, :current_position, :projectmanager, :webdesigner, :uiuxdesigner,
      :frontendengineer, :backendengineer]
    )
  end

  def current_status
    set_first_params.merge(username: [:lastname, :firstname].join(" "), english_name: [:eng_lastname, :eng_firstname].join(" "))
  end

  def current_detail
    params.require(:user).permit(detail_attributes: [:telephone, :company, :current_position, :projectmanager, :webdesigner, :uiuxdesigner, :frontendengineer, :backendengineer])
  end

  def user_params
    params.require(:user).permit(
      :picture, :picture_cache, :remove_picture, :lastname, :firstname,
      :eng_lastname, :eng_firstname, :email, :password, :password_confirmation, :role,
      detail_attributes: [:id, :birthday, :gender, :character_id, :character_name, :telephone, :company,
      :current_position, :address, :country, :languages, :introduction,
      :availability, :projectmanager, :webdesigner, :uiuxdesigner, :frontendengineer, :backendengineer,
      :schedule, :hourly_rate, :communication_tool, :website, :payment_address, :_destory])
  end

  def javascript_params
    user_params.merge(username: [:lastname, :firstname].join(" "))
  end

  def person_params
    params.require(:user).permit(:lastname, :firstname)
  end

  def person_name
    person_params.merge(@meber.set_username)
  end

  def birthday_join
    date = params[:birthday]

    if date["birthday(1i)"].empty? && date["birthday(2i)"].empty? && date["birthday(3i)"].empty?
      return
    end

    Date.new date["birthday(1i)"].to_i, date["birthday(2i)"].to_i, date["birthday(3i)"].to_i
  end

  def update_picture_url
    if Rails.env == 'production'
      @object = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
    else
      @object = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
    end
    @user.update(picture_url: @object)
  end

  def cabbala_character_set
    character_sub = 0
    birthday_length = @user.detail.birthday.strftime.split("-")
    birthday_length.each_with_index do |index, i|
      character_sub = character_sub + birthday_length[i].to_i
    end
    if character_sub != 11 then
      if character_sub != 22 then
        if character_sub.to_s.length > 1
          character_second = character_sub.to_s.split("-")
          character_sub = 0
          character_second.each_with_index do |index, i|
            character_sub = character_sub + character_second[i].to_i
          end
        end
      end
    end
    @character = Fruit.find(character_sub)
    params[:user][:detail_attributes][:character_id] = @character.id
    params[:user][:detail_attributes][:character_name] = @character.ename
    params.require(:user).permit(detail_attributes: [:id, :character_id, :character_name])
  end

  def fruits_character_set
    unless params[:commit] == 'パスワード更新'
      @user = User.find(params[:id])
      fnum = 0
      if @user.detail.birthday.present?
        birthday_length = @user.detail.birthday.strftime.split("-")
        if (birthday_length[0].to_i - 1920) % 4 == 0
          x1 = 54 + (birthday_length[0].to_i - 1920) / 4 * 21
          x2 = 25 + (birthday_length[0].to_i - 1920) / 4 * 21
          x3 = x1
          x4 = x2
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1

        elsif (birthday_length[0].to_i - 1920) % 4 == 1
          x1 = 0 + (birthday_length[0].to_i - 1921) / 4 * 21
          x2 = 31 + (birthday_length[0].to_i - 1921) / 4 * 21
          x3 = x1 - 1
          x4 = x2 - 1
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1

        elsif (birthday_length[0].to_i - 1920) % 4 == 2
          x1 = 5 + (birthday_length[0].to_i - 1922) / 4 * 21
          x2 = 36 + (birthday_length[0].to_i - 1922) / 4 * 21
          x3 = x1 - 1
          x4 = x2 - 1
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1

        elsif (birthday_length[0].to_i - 1920) % 4 == 3
          x1 = 10 + (birthday_length[0].to_i - 1923) / 4 * 21
          x2 = 41 + (birthday_length[0].to_i - 1923) / 4 * 21
          x3 = x1 - 1
          x4 = x2 - 1
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1
        end

        if birthday_length[1] == 1
          fnum = x1
        elsif birthday_length[1] == 2
          fnum = x2
        elsif birthday_length[1] == 3
          fnum = x3
        elsif birthday_length[1] == 4
          fnum = x4
        elsif birthday_length[1] == 5
          fnum = x5
        elsif birthday_length[1] == 6
          fnum = x6
        elsif birthday_length[1] == 7
          fnum = x7
        elsif birthday_length[1] == 8
          fnum = x8
        elsif birthday_length[1] == 9
          fnum = x9
        elsif birthday_length[1] == 10
          fnum = x10
        elsif birthday_length[1] == 11
          fnum = x11
        elsif birthday_length[1] == 12
          fnum = x12
        end

        fnum = fnum + birthday_length[2].to_i
        while fnum >= 60 do
          fnum = fnum - 60
        end

        while fnum < 0 do
          fnum = fnum + 60
        end

      else
        if (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 0
          x1 = 54 + (params[:birthday]["birthday(1i)"].to_i - 1920) / 4 * 21
          x2 = 25 + (params[:birthday]["birthday(1i)"].to_i - 1920) / 4 * 21
          x3 = x1
          x4 = x2
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1

        elsif (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 1
          x1 = 0 + (params[:birthday]["birthday(1i)"].to_i - 1921) / 4 * 21
          x2 = 31 + (params[:birthday]["birthday(1i)"].to_i - 1921) / 4 * 21
          x3 = x1 - 1
          x4 = x2 - 1
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1

        elsif (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 2
          x1 = 5 + (params[:birthday]["birthday(1i)"].to_i - 1922) / 4 * 21
          x2 = 36 + (params[:birthday]["birthday(1i)"].to_i - 1922) / 4 * 21
          x3 = x1 - 1
          x4 = x2 - 1
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1

        elsif (params[:birthday]["birthday(1i)"].to_i - 1920) % 4 == 3
          x1 = 10 + (params[:birthday]["birthday(1i)"].to_i - 1923) / 4 * 21
          x2 = 41 + (params[:birthday]["birthday(1i)"].to_i - 1923) / 4 * 21
          x3 = x1 - 1
          x4 = x2 - 1
          x5 = x3 + 1
          x6 = x4 + 1
          x7 = x5 + 1
          x8 = x6 + 1
          x9 = x7 + 2
          x10 = x8 + 1
          x11 = x9 + 1
          x12 = x10 + 1
        end

        if params[:birthday]["birthday(2i)"] == 1
          fnum = x1
        elsif params[:birthday]["birthday(2i)"] == 2
          fnum = x2
        elsif params[:birthday]["birthday(2i)"] == 3
          fnum = x3
        elsif params[:birthday]["birthday(2i)"] == 4
          fnum = x4
        elsif params[:birthday]["birthday(2i)"] == 5
          fnum = x5
        elsif params[:birthday]["birthday(2i)"] == 6
          fnum = x6
        elsif params[:birthday]["birthday(2i)"] == 7
          fnum = x7
        elsif params[:birthday]["birthday(2i)"] == 8
          fnum = x8
        elsif params[:birthday]["birthday(2i)"] == 9
          fnum = x9
        elsif params[:birthday]["birthday(2i)"] == 10
          fnum = x10
        elsif params[:birthday]["birthday(2i)"] == 11
          fnum = x11
        elsif params[:birthday]["birthday(2i)"] == 12
          fnum = x12
        end

        fnum = fnum + params[:birthday]["birthday(3i)"].to_i
        while fnum >= 60 do
          fnum = fnum - 60
        end

        while fnum < 0 do
          fnum = fnum + 60
        end
      end

      if fnum != 0
        @character = Fruit.find(fnum)
        params[:user][:detail_attributes][:character_id] = @character.id
        params[:user][:detail_attributes][:character_name] = @character.ename
        params.require(:user).permit(detail_attributes: [:id, :character_id, :character_name])
      end
    end
  end

  def resetpassword_params
    params.require(:user).permit(:email, :password, :role)
  end
end
