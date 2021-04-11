class ChangeDataSuperiorToUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :superior, 'integer USING CAST(superior AS integer)', default: false
  end
end
