class ChangeDataSuperiorToUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :superior, :integer, default: false
  end
end
