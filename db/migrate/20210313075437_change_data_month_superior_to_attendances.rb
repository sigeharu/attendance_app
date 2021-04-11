class ChangeDataMonthSuperiorToAttendances < ActiveRecord::Migration[6.0]
  def change
    change_column :attendances, :month_superior, :string
  end
end
