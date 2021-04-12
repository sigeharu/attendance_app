class AddConfirmationStatusToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :confirmation_status, :string
  end
end
