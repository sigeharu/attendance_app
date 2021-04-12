class AddBeforeFinishedAtToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :before_finished_at, :datetime
  end
end
