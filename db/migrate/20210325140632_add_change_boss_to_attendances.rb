class AddChangeBossToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :change_boss, :string
  end
end
