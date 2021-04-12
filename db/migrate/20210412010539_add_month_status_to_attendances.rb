class AddMonthStatusToAttendances < ActiveRecord::Migration[6.0]
  add_column :attendances, :month_status, :string
end
