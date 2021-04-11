class AddInstructorConfirmationToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :instructor_confirmation, :string
  end
end
