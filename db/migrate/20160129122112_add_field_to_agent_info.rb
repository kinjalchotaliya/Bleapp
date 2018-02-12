class AddFieldToAgentInfo < ActiveRecord::Migration
  def change
  	add_column :agent_infos, :is_enable, :boolean ,:default => false
  end
end
