class Admin::Masters::CategoriesController < ApplicationController
  def index
    @category = Category.all
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    if @category = Category.find_by(title: params[:category][:title])
      flash.alert =  "入力したカテゴリ名は既に登録されています。"
      render :new
    else
      @category = Category.new(complete_category_params)
      if @category.save
        flash.alert =  "カテゴリ登録に成功しました。"
        redirect_to admin_masters_categories_path
      else
        flash.alert =  "カテゴリ登録に失敗しました。"
        render :new
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash.alert =  "カテゴリ更新に成功しました。"
      redirect_to admin_masters_categories_path
    else
      flash.alert =  "カテゴリ更新に失敗しました。"
      render :new
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to admin_masters_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:id, :number, :classification, :title, :description)
  end

  def complete_category_params
    @classification = Category.find_by(number: params[:category][:number])
    category_params.merge(classification: @classification.classification)
  end
end
