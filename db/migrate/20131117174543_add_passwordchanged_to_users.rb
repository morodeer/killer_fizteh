class AddPasswordchangedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :passwordchanged, :boolean
  end
end
