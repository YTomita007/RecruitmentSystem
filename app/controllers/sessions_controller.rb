class SessionsController < ApplicationController
  before_action :set_user, only: [:create]
  protect_from_forgery except: [:create, :destroy, :resetlogin]

  def new
  end

  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_form_auth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      flash[:success] = "ユーザー認証が完了しました。"
      redirect_to user
    elsif @user.authenticate(session_params[:password])
      session[:login_user] = @user
      sign_in(@user)
      name = @user.username
      flash.alert = "ログインしました。 " + name +"さんこんにちは！"
      if session[:team_id].nil?
        redirect_to :root
      else
        redirect_to :reservation_createteams_teams
      end
    else
      flash.now[:danger] =  "メールとパスワードが一致しません"
      render action: 'new'
    end
  end

  def destroy
    sign_out
    session.delete(:login_user)
    flash.alert =  "ログアウトしました"
    redirect_to :root
  end

  def reset
    @email = params[:session][:email]
    begin
      NotificationMailer.passwordreset_message(@email).deliver_now
      flash.alert = "入力した " + @email + "へパスワード再設定用のメールを送信しました"
    rescue
      flash.now[:danger] = "入力したメールアドレスは存在しません"
      render action: 'forgetpassword'
    end
  end

  def resetlogin
    @user = User.find_by(email: params[:mail])
    session[:resetpassword] = "ResetPassword"
  end

  private

    def set_user
      @user = User.find_by!(email: session_params[:email])
    rescue
      flash.now[:danger] =  "メールとパスワードが一致しません"
      render action: 'new'
    end

    def session_params
      params.require(:session).permit(:email, :password)
    end
end
