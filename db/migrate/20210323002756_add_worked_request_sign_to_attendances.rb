class AddWorkedRequestSignToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :worked_request_sign, :integer
  end
end
