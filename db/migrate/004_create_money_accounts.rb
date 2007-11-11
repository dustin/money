class CreateMoneyAccounts < ActiveRecord::Migration
  def self.up
    create_table :money_accounts do |t|
      t.column :group_id, :integer, :null => false
      t.column :name, :string, :null => false
    end
    add_index :money_accounts, [:group_id, :name], :unique => true
  end

  def self.down
    drop_table :money_accounts
  end
end
