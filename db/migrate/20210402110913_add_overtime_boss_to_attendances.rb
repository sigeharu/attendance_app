class AddOvertimeBossToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :overtime_boss, :string
  end
end
