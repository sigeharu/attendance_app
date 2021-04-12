class AddCheckMonthApprovalToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :check_month_approval, :integer
  end
end
