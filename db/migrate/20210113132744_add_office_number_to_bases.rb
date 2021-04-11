class AddOfficeNumberToBases < ActiveRecord::Migration[6.0]
  def change
    add_column :bases, :office_number, :integer
  end
end
