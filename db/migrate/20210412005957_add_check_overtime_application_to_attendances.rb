class AddCheckOvertimeApplicationToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :check_overtime_application, :integer
  end
end
