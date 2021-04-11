module UsersHelper

  # 勤怠基本情報を指定のフォーマットで返します。
  def format_basic_info(time)
    format('%.2f', ((time.hour * 60) + time.min) / 60.0)
  end

  def after_today_readonly(day)
    Date.current <= day.worked_on && day.finished_at.blank?
  end

  # month_statusを確認
  def one_month_approval_status(status)
    Attendance.where(month_status: status)
  end
end
