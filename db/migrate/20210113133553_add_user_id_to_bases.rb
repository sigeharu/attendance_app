class AddUserIdToBases < ActiveRecord::Migration[6.0]
  def change
    add_column :bases, :user_id, :integer
  end
end
