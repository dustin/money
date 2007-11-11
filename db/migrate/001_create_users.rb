class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :login,                     :string, :null => false
      t.column :name,  :string, :limit => 64, :null => false
      t.column :email,                     :string, :null => false
      t.column :crypted_password,          :string, :limit => 40, :null => false
      t.column :salt,                      :string, :limit => 40, :null => false
      t.column :created_at,                :datetime, :null => false
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
