class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
	    t.integer :victim_id, unique: true, null: false
	    t.integer :owner_id, null: false
	    t.integer :killer_id, unique: true, null: false
	    t.boolean :killed, default: false
      t.timestamps
    end
  end
end
