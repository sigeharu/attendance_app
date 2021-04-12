class AddChangeFinishedAtToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :change_finished_at, :datetime
  end
end
