class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
        t.column :name, :string, :null => false
    end
    add_index :groups, :name, :unique => true

    create_table :group_user_map, :id => false do |t|
      t.column :group_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    add_index :group_user_map, [:group_id, :user_id], :unique => true
  end

  def self.down
    drop_table :groups
    drop_table :group_user_map
  end
end
