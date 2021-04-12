class AddBeforeStartedAtToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :before_started_at, :datetime
  end
end
