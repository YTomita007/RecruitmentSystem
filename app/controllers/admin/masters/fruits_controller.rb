class Admin::Masters::FruitsController < ApplicationController
  def index
    @fruit = Fruit.all
  end

  def new
    @fruit = Fruit.new
  end

  def edit
    @fruit = Fruit.find(params[:id])
    if Rails.env == 'production'
      if @fruit.fruitspic.present?
        @fruitspic = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @fruit.fruitspic.path
      end
      if @fruit.animalpic.present?
        @animalpic = 'https://workeasyhq.s3-ap-northeast-1.amazonaws.com/' + @fruit.animalpic.path
      end
    else
      if @fruit.fruitspic.present?
        @fruitspic = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @fruit.fruitspic.path
      end
      if @fruit.animalpic.present?
        @animalpic = 'https://workeasy-dev.s3-ap-northeast-1.amazonaws.com/' + @fruit.animalpic.path
      end
    end
  end

  def create
    if @fruit = Fruit.find_by(ename: params[:fruit][:ename])
      flash.alert =  "入力したフルーツは既に登録されています。"
      render :new
    else
      @fruit = Fruit.new(fruit_params)
      if @fruit.save
        flash.alert =  "フルーツの登録に成功しました。"
        redirect_to admin_masters_fruits_path
      else
        flash.alert =  "フルーツの登録に失敗しました。"
        render :new
      end
    end
  end

  def update
    @fruit = Fruit.find(params[:id])
    if @fruit.update(fruit_params)
      flash.alert =  "フルーツの更新に成功しました。"
      redirect_to admin_masters_fruits_path
    else
      flash.alert =  "フルーツの更新に失敗しました。"
      render :edit
    end
  end

  def destroy
    @fruit = Fruit.find(params[:id])
    @fruit.destroy
    flash.alert =  "フルーツを削除しました。"
    redirect_to admin_masters_fruits_path
  end

  private

  def fruit_params
    params.require(:fruit).permit(:id, :ename, :wname, :animal, :group, :cabbala, :description,
      :fruitspic, :fruitspic_cache, :remove_fruitspic, :animalpic, :animalpic_cache, :remove_animalpic
    )
  end
end
