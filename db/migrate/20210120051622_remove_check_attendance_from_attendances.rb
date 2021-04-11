class RemoveCheckAttendanceFromAttendances < ActiveRecord::Migration[6.0]
  def up
    remove_column :attendances, :check_attendance
  end

  def down
    add_column :attendances, :check_attendance, :integer
  end
end
