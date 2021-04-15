module AttendancesHelper
  
  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_time(attendance)
    unless attendance.next_day?
      format("%.2f", (((attendance.finished_at.floor_to(15.minutes) - attendance.started_at.floor_to(15.minutes)) / 60) / 60.0))
    else
      format("%.2f", (((attendance.finished_at.floor_to(15.minutes) - attendance.started_at.floor_to(15.minutes)) / 60) / 60.0) + 24)
    end
  end

  def change_time_working_time(attendance)
    unless attendance.confirmation_next_day?
      format("%.2f", (((attendance.change_finished_at.floor_to(15.minutes) - attendance.change_started_at.floor_to(15.minutes)) / 60) / 60.0))
    else
      format("%.2f", (((attendance.change_finished_at.floor_to(15.minutes) - attendance.change_started_at.floor_to(15.minutes)) / 60) / 60.0) + 24)
    end
  end

  def scheduled_over_time(day, user)
    day.scheduled_end_time.floor_to(15.minutes)
    finish1 = day.scheduled_end_time.strftime('%H').to_i * 60
    finish2 = day.scheduled_end_time.floor_to(15.minutes).strftime('%M').to_i
    work1 = user.work_end_time.strftime('%H').to_i * 60
    work2 = user.work_end_time.floor_to(15.minutes).strftime('%M').to_i

    a = (finish1 + finish2) - (work1 + work2)
    unless day.overtime_next_day?
      format("%.2f", a/60.to_f)
    else
      format("%.2f", a/60.to_f + 24)
    end
  end

  def scheduled_over_time_show(day, user)
    day.scheduled_end_time.floor_to(15.minutes)
    finish1 = day.scheduled_end_time.strftime('%H').to_i * 60
    finish2 = day.scheduled_end_time.floor_to(15.minutes).strftime('%M').to_i
    work1 = user.work_end_time.strftime('%H').to_i * 60
    work2 = user.work_end_time.floor_to(15.minutes).strftime('%M').to_i

    a = (finish1 + finish2) - (work1 + work2)
    unless day.next_day?
      format("%.2f", a/60.to_f)
    else
      format("%.2f", a/60.to_f + 24)
    end
  end
end