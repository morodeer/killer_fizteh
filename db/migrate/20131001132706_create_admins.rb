class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
	    t.string :name
	    t.string :surname
      t.timestamps
    end
  end
end
