class AddConfirmationModifyToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :confirmation_modify, :integer
  end
end
