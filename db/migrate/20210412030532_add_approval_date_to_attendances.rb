class AddApprovalDateToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :approval_date, :datetime
  end
end
