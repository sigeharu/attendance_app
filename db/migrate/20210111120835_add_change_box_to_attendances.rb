class AddChangeBoxToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :change_box, :boolean
  end
end
