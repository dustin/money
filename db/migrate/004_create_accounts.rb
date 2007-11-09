class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :group_id, :integer, :null => false
      t.column :name, :string, :null => false
    end
    add_index :accounts, [:group_id, :name], :unique => true
  end

  def self.down
    drop_table :accounts
  end
end
