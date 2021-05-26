class Admin::Users::AdminusersController < Admin::Base
  def new
    @user = User.new
    @user.build_detail
    session[:agent] = true
  end

  def selection
    @user = User.new
    @alluser = User.all
  end

  def default
    @user = User.find(params[:user][:id])
    @detail = Detail.find(@user.id)
    @memberskills = MemberSkill.where(user_id: @user.id)
    @career = Career.where(user_id: @user.id)
    @paperclip = Paperclip.find_by(user_id: @user.id)
    @license = License.where(user_id: @user.id)
    session[:agent] = true
  end

  def create
    @user = User.new(agent_user_params)
    if @user.save
      session.delete(:agent)
      flash.alert =  "新しく" + @user.username + "さんを登録しました。"
      redirect_to admin_users_adminusers_path
    else
      flash.alert =  "メンバー登録に失敗しました"
      render :new
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    @career = Career.where(user_id: @user.id)
    @license = License.where(user_id: @user.id)
    @paperclip = Paperclip.find_by(user_id: @user.id)
    @memberskills = MemberSkill.where(user_id: @user.id)
    if @user.update(default_params)
      @career.destroy_all
      @license.destroy_all
      @memberskills.destroy_all
      if @paperclip
        @paperclip.destroy
      end
      session.delete(:agent)
      flash.alert =  @user.username + "さんのデータを初期化しました。"
      redirect_to admin_users_adminusers_path
    else
      flash.alert =  "初期化に失敗しました"
      redirect_to admin_users_adminusers_path
    end
  end

  private

  def agent_user_params
    params.require(:user).permit(:administrator,
      :picture, :picture_cache, :remove_picture, :lastname, :firstname,
      :eng_lastname, :eng_firstname, :email, :password, :password_confirmation, :role,
      detail_attributes: [:id, :birthday, :gender, :character_id, :character_name, :telephone, :company,
      :current_position, :address, :country, :languages, :introduction,
      :availability, :projectmanager, :webdesigner, :uiuxdesigner, :frontendengineer, :backendengineer,
      :schedule, :hourly_rate, :communication_tool, :website, :_destory]
    )
  end

  def default_params
    params.require(:user).permit(:id, :administrator, :english_name, :picture, :picture_url,
      detail_attributes: [:id, :birthday, :gender, :character_id, :character_name, :telephone, :company,
      :current_position, :address, :country, :languages, :introduction,
      :availability, :projectmanager, :webdesigner, :uiuxdesigner, :frontendengineer, :backendengineer,
      :schedule, :hourly_rate, :communication_tool, :website, :_destory],
      careers_attributes: [:id, :title, :description, :start_duration, :end_duration, :_destroy],
      licenses_attributes: [:id, :title, :acquisition, :point, :_destroy],
      paperclip_attributes: [:id, :title, :image, :image_cache, :remove_image, :link, :_destroy],
      memberskills_attributes: [:id, :user_id, :skill_id, :title]
    )
  end
end
