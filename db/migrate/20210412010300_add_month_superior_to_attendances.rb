class AddMonthSuperiorToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :month_superior, :string
  end
end
