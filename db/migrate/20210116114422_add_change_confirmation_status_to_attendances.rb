class AddChangeConfirmationStatusToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :change_confirmation_status, :integer
  end
end
