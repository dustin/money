class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string, :limit => 16, :null => false
      t.column :name, :string, :null => false
      t.column :hash, :string, :null => false
    end
    add_index :users, :username, :name => "idx_user_username", :unique => true
  end

  def self.down
    drop_table :users
  end
end
