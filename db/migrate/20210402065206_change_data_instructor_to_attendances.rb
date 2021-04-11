class ChangeDataInstructorToAttendances < ActiveRecord::Migration[6.0]
  def change
    change_column :attendances, :instructor, :string
  end
end
