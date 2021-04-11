class AddApplyMonthToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :apply_month, :date
  end
end
