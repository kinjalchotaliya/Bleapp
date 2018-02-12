class AddAudioToBleeapp < ActiveRecord::Migration
  def change
    add_attachment :bleeapps, :audio
  end
end
