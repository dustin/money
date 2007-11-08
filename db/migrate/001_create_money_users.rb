class CreateMoneyUsers < ActiveRecord::Migration
  def self.up
    create_table :money_users do |t|
      t.column :username, :string, :limit => 16, :null => false
      t.column :name, :string, :null => false
      t.column :hash, :string, :null => false
    end
    add_index :money_users, :username, :name => "idx_user_username", :unique => true
  end

  def self.down
    drop_table :money_users
  end
end
