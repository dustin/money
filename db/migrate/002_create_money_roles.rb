class CreateMoneyRoles < ActiveRecord::Migration
  def self.up
    create_table :money_roles do |t|
      t.column :name, :string, :limit => 16, :null => false
    end
    add_index :money_roles, :name, :name => "idx_role_rolename", :unique => true

    create_table :money_user_roles_map, :id => false do |t|
      t.column :money_role_id, :integer, :null => false
      t.column :money_user_id, :integer, :null => false
    end
    add_index :money_user_roles_map, [:money_role_id, :money_user_id],
      :name => "idx_user_role_map", :unique => true
  end

  def self.down
    drop_table :money_roles
    drop_table :money_user_roles_map
  end
end
