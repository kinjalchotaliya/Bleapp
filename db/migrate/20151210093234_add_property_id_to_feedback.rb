class AddPropertyIdToFeedback < ActiveRecord::Migration
  def change
  	add_reference :feedbacks, :property, index: true
    add_foreign_key :feedbacks, :properties
  end
end
