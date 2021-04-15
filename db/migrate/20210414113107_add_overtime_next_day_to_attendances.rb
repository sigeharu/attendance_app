class AddOvertimeNextDayToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :overtime_next_day, :boolean
  end
end
