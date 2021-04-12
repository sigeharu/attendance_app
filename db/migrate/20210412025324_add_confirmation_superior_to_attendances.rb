class AddConfirmationSuperiorToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :confirmation_superior, :string
  end
end
