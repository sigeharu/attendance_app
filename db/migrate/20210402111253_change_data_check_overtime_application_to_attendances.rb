class ChangeDataCheckOvertimeApplicationToAttendances < ActiveRecord::Migration[6.0]
  def change
    change_column :attendances, :check_overtime_application, :integer
  end
end
