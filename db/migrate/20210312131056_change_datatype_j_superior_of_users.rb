class ChangeDatatypeJSuperiorOfUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :superior, :boolean, default: false
  end
end
