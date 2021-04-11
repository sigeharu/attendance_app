# frozen_string_literal: true

class BasesController < ApplicationController
  before_action :set_base, only: %i[edit update show destroy]
  before_action :logged_in_user, only: %i[index update show destroy]
  before_action :admin_user

  def index
    @base = Base.new
    @bases = Base.all
  end

  def new
    @base = Base.new
  end

  def create
    @base = Base.new(params[:base].permit(:office_number, :office_name, :office_category))
    @base.user_id = current_user.id
    if @base.save
      flash[:success] = '拠点情報を作成しました'
      redirect_to user_bases_url
    else
      flash[:notice] = '拠点情報の作成に失敗しました'
      redirect_to user_bases_url
    end
  end

  def show; end

  def edit; end

  def update
    @base.user_id = current_user.id
    if @base.update_attributes(base_params)
      flash[:success] = '拠点情報を更新しました'
      redirect_to user_bases_url
    else
      flash[:danger] = '更新に失敗しました'
      render :index
    end
  end

  def destroy
    @base.destroy
    flash[:success] = "#{@base.office_name}を削除しました"
    redirect_to user_bases_url
  end

  private

  def set_base
    @base = Base.find(params[:id])
  end

  def base_params
    params.require(:base).permit(:office_number, :office_name, :office_category)
  end
end
