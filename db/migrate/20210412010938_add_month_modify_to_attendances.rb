class AddMonthModifyToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :month_modify, :boolean, default: false
  end
end
