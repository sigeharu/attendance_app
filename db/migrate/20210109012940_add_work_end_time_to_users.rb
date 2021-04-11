class AddWorkEndTimeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :work_end_time, :datetime, default: Time.current.change(hour: 18, min: 0, sec: 0)
  end
end
