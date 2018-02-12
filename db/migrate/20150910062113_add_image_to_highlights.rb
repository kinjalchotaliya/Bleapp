class AddImageToHighlights < ActiveRecord::Migration
  def up
    add_attachment :highlights, :image
  end

  def down
    remove_attachment :highlights, :image
  end
end
