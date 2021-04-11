class AddEnployeeNumberToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :enployee_number, :integer
  end
end
