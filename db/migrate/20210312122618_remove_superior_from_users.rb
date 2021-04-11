class RemoveSuperiorFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :superior, :integer
  end
end
