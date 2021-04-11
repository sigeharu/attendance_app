class AddChangeStartedAtToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :change_started_at, :datetime
  end
end
