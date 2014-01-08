class RemoveKillerIdAndAddUniqueIndexToUsers < ActiveRecord::Migration
  def change
		remove_column :users, :target_id
		add_index :cards, :killer_id, unique: :true
		add_index :cards, :victim_id, unique: :true

  end
end
