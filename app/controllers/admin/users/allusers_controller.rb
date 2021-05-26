class Admin::Users::AllusersController < Admin::Base
  def index
    date = Array.new
    time = Array.new
    @user = User.all
    @user.each_with_index do |index, i|
      date[i] = @user[i].created_at.to_s.split(" ").first
      time[i] = @user[i].created_at.to_s.split(" ").second
    end
    @resistdate = date
    @resisttime = time
  end

  def edit
    @user = User.find(params[:id])
    if @user.picture.present?
      if Rails.env == 'production'
        @object = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      else
        @object = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @user.picture.path
      end
    end
    @detail = Detail.find(@user.id)
    @memberskills = MemberSkill.where(user_id: @user.id)
    @skill = Skill.find(@memberskills.map(&:skill_id))
    @career = Career.where(user_id: @user.id)
    @paperclip = Paperclip.find_by(user_id: @user.id)
    @license = License.where(user_id: @user.id)
    if @paperclip
      if @paperclip.image.present?
        if Rails.env == 'production'
          # @thumbnail = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.versions[:web_thumb].path
          @portfolio = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.path
        else
          # @thumbnail = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.versions[:web_thumb].path
          @portfolio = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @paperclip.image.path
        end
      end
    end
  end

  def activechange
    @user = User.find(params[:format])
    if @user.activate == true
      @user.update(activate: false)
      flash.alert =  "メンバーのアクティベートを無効にしました。"
      redirect_to edit_admin_users_alluser_path(@user.id)
    else
      @user.update(activate: true)
      flash.alert =  "メンバーのアクティベートを有効にしました。"
      redirect_to edit_admin_users_alluser_path(@user.id)
    end
  end

  def adminchange
    @user = User.find(params[:format])
    if @user.administrator == true
      @user.update(administrator: false)
      flash.alert =  "メンバーを管理者から外しました。"
      redirect_to edit_admin_users_alluser_path(@user.id)
    elsif @user.administrator.nil?
      @user.update(administrator: true)
      flash.alert =  "メンバーを管理者にしました。"
      redirect_to edit_admin_users_alluser_path(@user.id)
    else
      @user.update(administrator: true)
      flash.alert =  "メンバーを管理者にしました。"
      redirect_to edit_admin_users_alluser_path(@user.id)
    end
  end
end
