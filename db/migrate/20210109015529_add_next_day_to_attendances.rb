class AddNextDayToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :next_day, :boolean, default: false
  end
end
