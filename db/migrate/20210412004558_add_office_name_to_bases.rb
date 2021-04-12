class AddOfficeNameToBases < ActiveRecord::Migration[6.0]
  def change
    add_column :bases, :office_name, :string
  end
end
