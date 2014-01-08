class RemoveNullFromCardKillerId < ActiveRecord::Migration
  def change
		change_column :cards, :killer_id, :integer, null: true
  end
end
