require "date"

class AttendancesController < ApplicationController
  before_action :set_user, except: [:update, :edit_overtime_application, :update_overtime_application]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :superior_or_correct_user, only: [:edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:show, :edit_one_month]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def show
    @year = (2020..2035).map
    @month = (1..12).map
    @log = log_month(@user).order(worked_on: "ASC")
  end

  def update
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0).floor_to(15.minutes))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0).floor_to(15.minutes))
        flash[:info] = "お疲れさまでした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to current_user
  end
  
  def edit_one_month
    @superior = User.find_superior(@user)
  end
  
  def update_one_month
    attendances = []
    change_confirmation_params.each do |id, item|
      if item[:confirmation_superior].present? && item[:note].present?
        if item["change_started_at(4i)"].empty? && item["change_started_at(5i)"].empty?
          item[:change_started_at] = nil
        else
          item[:change_started_at] = DateTime.new(2020, 1, 1, item["change_started_at(4i)"].to_i, item["change_started_at(5i)"].to_i, 0, '+9:00')
        end
        if item["change_finished_at(4i)"].empty? && item["change_finished_at(5i)"].empty?
          item[:change_finished_at] = nil
        else
          item[:change_finished_at] = DateTime.new(2020, 1, 1, item["change_finished_at(4i)"].to_i, item["change_finished_at(5i)"].to_i, 0, '+9:00')
        end
        if item[:change_started_at].blank? && item[:change_finished_at].blank?
          Attendance.where(id: id.to_i).each do |attendance|
            attendance.change_started_at = nil
            attendance.change_finished_at = nil
            attendance.note = item[:note]
            attendance.worked_request_sign = item[:worked_request_sign]
            attendance.confirmation_superior = item[:confirmation_superior]
            attendance.confirmation_status = "申請中"
            attendances << attendance
          end
        elsif (item[:change_started_at].present? && item[:change_finished_at].present?)
          if (item[:change_started_at] < item[:change_finished_at]) || (item[:confirmation_next_day] == "true")
            Attendance.where(id: id.to_i).each do |attendance|
              attendance.change_started_at = item[:change_started_at].change(sec: 0)
              attendance.change_finished_at = item[:change_finished_at].change(sec: 0)
              attendance.note = item[:note]
              attendance.confirmation_next_day = item[:confirmation_next_day]
              attendance.worked_request_sign = item[:worked_request_sign]
              attendance.confirmation_superior = item[:confirmation_superior]
              attendance.confirmation_status = "申請中"
              attendances << attendance
            end
          else
            err = flash[:danger] = "内容に不備があったため申請できませんでした｡"
            redirect_to user_url(@user) and return
          end
        else
          err
        end
      end
    end
    Attendance.import attendances, on_duplicate_key_update: [:change_started_at, :change_finished_at,
                                                             :note, :confirmation_next_day, :worked_request_sign, :confirmation_superior, :confirmation_status]
    flash[:success] = "勤怠情報変更を申請しました｡"
    redirect_to user_url(@user) and return
  end

  def attendance_change_confirmation
    @attendances = Attendance.user_change_confirmation(@user)
  end

  def update_attendance_change_confirmation
    attendances = []
    status_count = []
    confirmation_approval_params.each do |id, item|
      if item[:confirmation_modify].to_i == 1
        unless (item[:confirmation_status] == "申請中") || (item[:confirmation_status] == "なし")
          attendance = Attendance.find(id)
          attendance.change_boss = attendance.confirmation_superior
          attendance.confirmation_superior = nil
          attendance.confirmation_status = item[:confirmation_status]
          if item[:confirmation_status] == "承認"
            attendance.before_started_at = attendance.started_at
            attendance.before_finished_at = attendance.finished_at
            attendance.started_at = attendance.change_started_at
            attendance.finished_at = attendance.change_finished_at
            attendance.approval_date = Date.current
            if attendance.confirmation_next_day == true
              attendance.next_day = true
            end
          else
            attendance.change_started_at = nil
            attendance.change_finished_at = nil
            attendance.confirmation_next_day = false
          end
          status_count.push(item[:confirmation_status])
          attendances << attendance
        end
      end
    end
    Attendance.import attendances, on_duplicate_key_update:
      [:change_boss, :confirmation_superior, :confirmation_status,
       :started_at, :finished_at, :approval_date, :next_day, :confirmation_next_day,
       :change_started_at, :change_finished_at, :before_started_at, :before_finished_at]
    count_flash(status_count, "勤怠変更申請")
    redirect_to user_url(@user)
  end
  
  def edit_overtime_application
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @superior = User.find_superior(current_user)
  end

  def update_overtime_application
    @attendance = Attendance.find(params[:id])
    if overtime_params[:instructor].present?
      @attendance.update!(overtime_params)
      @attendance.update!(instructor_confirmation: "申請中")
      flash[:success] = "残業申請しました"
    else
      flash[:danger] = "申請をキャンセルしました。"
    end
    redirect_to current_user
  end
  
  def edit_superior_overtime_application
    @attendances = Attendance.user_overtime_application(@user)
  end
  
  def update_superior_overtime_application
    attendances = []
    status_count = []
    overtime_apply_params.each do |id, item|
      if item[:change_box] == "true"
        unless (item[:instructor_confirmation] == "申請中") || (item[:instructor_confirmation] == "なし")
          attendance = Attendance.find(id)
          attendance.overtime_boss = attendance.instructor
          attendance.instructor = nil
          attendance.instructor_confirmation = item[:instructor_confirmation]
          attendance.next_day = attendance.overtime_next_day
          if item[:instructor_confirmation] == "否認"
            attendance.check_overtime_application = 2
            attendance.scheduled_end_time = nil
            attendance.business_processing_content = nil
            attendance.overtime_next_day = nil
          else
            attendance.check_overtime_application = 1
          end
          status_count.push(item[:instructor_confirmation])
          attendances << attendance
        end
      end
    end
    Attendance.import attendances, on_duplicate_key_update:
      [:overtime_boss, :instructor, :instructor_confirmation,
       :check_overtime_application, :scheduled_end_time, :business_processing_content,
       :next_day]
    count_flash(status_count, "残業申請")
    redirect_to user_url(@user)
  end

  # 1ヶ月分の勤怠申請
  def update_month_superior
    @attendance = Attendance.where(user_id: month_superior_params[:user_id],
                                   worked_on: params[:date])
    if month_superior_params[:month_superior].blank?
      flash[:danger] = '所属長を選択してください｡'
    else
      @attendance.update_all(month_superior_params)
      superior = month_superior_params[:month_superior]
      superior = "#{superior}に申請中"
      @attendance.update(check_month_approval: 1, change_month_superior: "#{superior}")
      flash[:success] = '1ヶ月分の勤怠を申請しました｡'
    end
    redirect_to @user
  end

  def month_approval
    @attendances = Attendance.user_month_approval(@user)
  end

  def update_month_approval
    attendances = []
    status_count = []
    month_approval_params.each do |id, item|
      unless item[:month_status] == "なし"
        if (item[:month_modify] == "true") && (item[:month_status] != "申請中")
          attendance = Attendance.find(id)
          superior = attendance.month_superior
          if item[:month_status] == "承認"
            superior = "#{superior}により承認済"
          elsif item[:month_status] == "否認"
            superior = "#{superior}により否認"
          end
          attendance.change_month_superior = superior
          attendance.month_status = item[:month_status]
          attendance.check_month_approval = 2
          attendance.month_superior = nil
          status_count.push(item[:month_status])
          attendances << attendance
        end
      end
    end
    Attendance.import attendances, on_duplicate_key_update:
      [:change_month_superior, :month_status, :check_month_approval,
       :month_superior]
    count_flash(status_count, "所属長承認申請")
    redirect_to user_url(@user)
  end

  private
    # 1ヶ月分の申請の際の上長選択
    def month_superior_params
      params.require(:attendance).permit(:month_superior).merge(user_id: params[:id], month_status: '申請中',
                                                                apply_month: params[:date].to_date).to_h
    end

    # 1ヶ月分の勤怠申請の承認
    def month_approval_params
      params.require(:user).permit(attendances: [:month_status, :month_modify])[:attendances]
    end

    # 勤怠情報変更申請を扱う
    def change_confirmation_params
      params.require(:user).permit(attendances: [:change_started_at, :change_finished_at, :note, :confirmation_next_day,
                                                 :confirmation_superior, :confirmation_status, :worked_request_sign])[:attendances]
    end

    # 勤怠変更申請を承認する
    def confirmation_approval_params
      params.require(:user).permit(attendances: [:confirmation_status, :confirmation_modify])[:attendances]
    end

    # 勤怠ログ年月データ
    def log_params
      params.permit(:year, :month)
    end
    
    # 残業情報を扱う
    def overtime_params
      params.require(:attendance).permit(:worked_on, :scheduled_end_time, :overtime_next_day,
                                         :business_processing_content, :instructor)
    end

    # 残業申請の承認を扱う
    def overtime_apply_params
      params.require(:user).permit(attendances: [:instructor_confirmation, :change_box])[:attendances]
    end

    # 勤怠ログの検索メソッド
    def log_month(user)
      if log_params[:year].present? && log_params[:month].present?
        year = log_params[:year].to_i
        month = log_params[:month].to_i
        log = Date.new(year, month)
      else
        log = Date.current
      end
      log_mon = user.attendances.where(worked_on: log.beginning_of_month..log.end_of_month)
      log_mon.where(confirmation_status: "承認")
    end

    def started_at_join
      unless item["change_started_at(1i)"].empty? && item["change_started_at(2i)"].empty? && item["change_started_at(3i)"].empty? && item["change_started_at(4i)"].empty? && item["change_started_at(5i)"].empty?
        Time.new(item["change_started_at(1i)"].to_i, item["change_started_at(2i)"].to_i, item["change_started_at(3i)"], item["change_started_at(4i)"].to_i, item["change_started_at(5i)"].to_i)
      end
    end

    def finished_at_join

    end

    # お知らせ承認後のカウントするフラッシュ表示
    def count_flash(status_count, approval)
      status1 = status_count.select{ |n| n == "承認" }.count
      status2 = status_count.select{ |n| n == "否認" }.count
      flash[:success] = "#{approval}で#{status1}件の承認と#{status2}件の否認を更新しました｡"
    end

    # beforeフィルター

    # 上長ユーザー､または現在ログインしているユーザーを許可します｡

    def superior_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.superior?
        flash[:danger] = "編集権限がありません｡"
        redirect_to(root_url)
      end
    end

    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
end
