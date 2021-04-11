class AddBusinessProcessingContentToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :business_processing_content, :text
  end
end
