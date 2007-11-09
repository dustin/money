class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name, :string, :limit => 16, :null => false
    end
    add_index :roles, :name, :name => "idx_role_rolename", :unique => true

    create_table :user_roles_map, :id => false do |t|
      t.column :role_id, :integer, :null => false
      t.column :user_id, :integer, :null => false
    end
    add_index :user_roles_map, [:role_id, :user_id],
      :name => "idx_user_role_map", :unique => true
  end

  def self.down
    drop_table :roles
    drop_table :user_roles_map
  end
end
