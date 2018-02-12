class AddAvatarToAgentInfo < ActiveRecord::Migration
  def up
    add_attachment :agent_infos, :avatar
  end

  def down
    remove_attachment :agent_infos, :avatar
  end
end
