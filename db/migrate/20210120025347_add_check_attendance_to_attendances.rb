class AddCheckAttendanceToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :check_attendance, :integer
  end
end
