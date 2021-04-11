class AddChangeMonthSuperiorToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :change_month_superior, :string
  end
end
