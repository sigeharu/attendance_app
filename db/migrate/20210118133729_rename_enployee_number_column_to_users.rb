class RenameEnployeeNumberColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :enployee_number, :employee_number
  end
end
