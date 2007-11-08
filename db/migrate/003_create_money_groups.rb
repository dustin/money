class CreateMoneyGroups < ActiveRecord::Migration
  def self.up
    create_table :money_groups do |t|
        t.column :name, :string, :null => false
    end
    add_index :money_groups, :name, :unique => true

    create_table :money_group_user_map, :id => false do |t|
      t.column :money_group_id, :integer, :null => false
      t.column :money_user_id, :integer, :null => false
    end
    add_index :money_group_user_map, [:money_group_id, :money_user_id], :unique => true
  end

  def self.down
    drop_table :money_groups
    drop_table :money_group_user_map
  end
end
