# frozen_string_literal: true

require 'csv'

class UsersController < ApplicationController
  before_action :set_user, only: %i[show csv_show edit update destroy index_attendance]
  before_action :logged_in_user, only: %i[index edit update destroy index_attendance]
  before_action :correct_user, only: %i[edit update]
  before_action :not_admin_user, only: :show
  before_action :admin_user, only: %i[index user_update import index_attendance destroy]
  before_action :set_one_month, only: %i[show]

  def index
    @users = User.paginate(page: params[:page], per_page: 20).where.not(id: current_user.id).order(id: "ASC")

    @user = if params[:id].present?
              User.find_by(id: @users.id)
            else
              User.new
            end
  end

  def user_update
    @user = User.find(params[:id])
    if @user.update!(user_params)
      flash[:success] = 'ユーザー情報を更新しました｡'
      redirect_to users_url
    else
      flash[:danger] = 'ユーザー情報を更新できませんでした｡'
      redirect_to users_url
    end
  end

  def import
    if User.import(params[:file])
      flash[:success] = 'CSVをインポートできました｡'
      redirect_to users_url
    else
      flash[:danger] = 'インポートできませんでした｡'
      redirect_to users_url
    end
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @attendance = Attendance.find(params[:id])
    @month_superior = Attendance.where(month_superior: @user.name)
    @month_superior_user = @user.attendances.where.not(month_superior: @user.name)
    @confirmation_superior = Attendance.where(confirmation_superior: @user.name)
    @confirmation_superior_user = @user.attendances.where.not(confirmation_superior: @user.name)
    @overtime_superior = Attendance.where(instructor: @user.name)
    @overtime_superior_user = @user.attendances.where.not(instructor: @user.name)
    @month_status_apply = Attendance.where(month_superior: @user.name, month_status: '申請中')
    @confirmation_status_apply = Attendance.where(confirmation_superior: @user.name, confirmation_status: '申請中')
                                           .or(Attendance.where(confirmation_superior: @user.name, confirmation_status: 'なし'))
    @overtime_status_apply = Attendance.where(instructor: @user.name, instructor_confirmation: "申請中")
    @month_approval = Attendance.where(month_modify: true)
    @superior = User.where(superior: true).where.not(name: current_user.name)
    @check_month_superior = @user.attendances.where(apply_month: @first_day)
  end

  # csv出力
  def csv_show
    @first_day =  params[:date].to_date
    @last_day = @first_day.end_of_month
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_attendance_csv(@attendances)
      end
    end
  end

  # csv出力
  def send_attendance_csv(attendances)
    csv_data = CSV.generate(row_sep: "\r\n", encoding:Encoding::CP932)  do |csv|
      header = %w(日付 出社時間 退社時間)
      csv << header
      attendances.each do |attendance|
        if attendance.started_at.blank? && attendance.finished_at.blank?
          values = [
            attendance.worked_on_date,
            "",
            ""
          ]
        elsif attendance.started_at.blank?
          values = [
            attendance.worked_on_date,
            "",
            attendance.finished_at_time
          ]
        elsif attendance.finished_at.blank?
          values = [
            attendance.worked_on_date,
            attendance.started_at_time,
            ""
          ]
        else
          values = [
            attendance.worked_on_date,
            attendance.started_at_time,
            attendance.finished_at_time
          ]
        end

        csv << values
      end
    end
    send_data(csv_data, filename: "#{current_user.name}の#{@first_day.year}年の#{@first_day.mon}月の時間管理票.csv")
  end



  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to root_url
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def index_attendance
    @users = User.all.includes(:attendances)
  end

  private



  def user_params
    params.require(:user).permit(:name, :email, :department, :employee_number, :card_id,
                                 :password, :password_confirmation, :basic_time,
                                 :work_start_time, :work_end_time)
  end

  def month_params
    params.require(:user).permit(:month_superior, :month_status, :apply_month)
  end
end
