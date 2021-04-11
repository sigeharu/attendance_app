class AddMonthStatusToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :month_status, :string
  end
end
