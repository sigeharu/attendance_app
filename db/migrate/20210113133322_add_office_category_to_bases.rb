class AddOfficeCategoryToBases < ActiveRecord::Migration[6.0]
  def change
    add_column :bases, :office_category, :string
  end
end
