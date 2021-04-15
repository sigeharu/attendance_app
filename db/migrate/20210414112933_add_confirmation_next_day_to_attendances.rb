class AddConfirmationNextDayToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :confirmation_next_day, :boolean
  end
end
