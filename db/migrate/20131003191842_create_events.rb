class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
	    t.string :event_type
	    t.integer :source_id
	    t.integer :target_id
	    t.integer :card_id
	    t.integer :card_count
	    t.integer :new_target_id
	    t.string :method
      t.timestamps
    end
  end
end
