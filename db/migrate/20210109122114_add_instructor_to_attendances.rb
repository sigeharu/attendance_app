class AddInstructorToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :instructor, :integer
  end
end
