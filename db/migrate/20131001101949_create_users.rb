class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	    t.string :name
	    t.string :surname
	    t.boolean :dead
	    t.integer :target_id
	    t.string :killing_word

	    t.integer :bf_count
	    t.boolean :banned
	    t.string :ban_reason
      t.timestamps
    end
  end
end
