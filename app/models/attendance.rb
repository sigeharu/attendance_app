class Attendance < ApplicationRecord
  belongs_to :user

  validates :change_box, acceptance: true
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }

  scope :user_id_group, -> { order(:user_id).group_by(&:user_id) }
  scope :user_change_confirmation, -> (user) { where(confirmation_status: '申請中',
                                                     confirmation_superior: user.name).user_id_group }
  scope :user_month_approval, -> (user) { where(month_status: '申請中', month_superior: user.name).user_id_group }
  scope :user_overtime_application, -> (user) { where(instructor_confirmation: "申請中",
                                                      instructor: user.name).user_id_group }
  scope :find_applying, -> { where(confirmation_status: "申請中" || "なし") }

  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # 編集出勤､退社時間がない場合翌日チェックは無効
  validate :confirmation_next_day_time_present


  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      if next_day == "false"
        errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
      end
    end
  end

  def change_finished_at_is_invalid_without_a_change_started_at
    errors.add(:change_started_at, "が必要です") if change_started_at.blank? && change_finished_at.present?
  end

  def change_started_at_than_change_finished_at_fast_if_invalid
    if change_started_at.present? && change_finished_at.present?
      if confirmation_next_day == "true"
        errors.add(:change_started_at, "より早い退社時間は無効です") if change_started_at > change_finished_at
      end
    end
  end

  def confirmation_next_day_time_present
    if change_started_at.present? && change_finished_at.present?
      if confirmation_next_day == "true"
        errors.add(:confirmation_next_day, "時間が設定されていません")
      end
    end
  end

  def started_at_time
    started_at.floor_to(15.minutes)
  end

  def finished_at_time
    finished_at.floor_to(15.minutes)
  end

  def change_started_at_time
    change_started_at.floor_to(15.minutes) if change_started_at.present?
  end

  def change_finished_at_time
    change_finished_at.floor_to(15.minutes) if change_finished_at.present?
  end

  def worked_on_date
    worked_on.strftime("%m/%d")
  end
end
