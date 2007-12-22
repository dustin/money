class CreateMoneyTransactions < ActiveRecord::Migration
  def self.up
    create_table :money_transactions do |t|
      t.column :user_id, :integer, :null => false
      t.column :money_account_id, :integer, :null => false
      t.column :category_id, :integer, :null => false
      t.column :descr, :string, :null => false
      t.column :amount, :decimal, :precision => 9, :scale => 2, :null => false
      t.column :ds, :date, :null => false
      t.column :reconciled, :boolean, :default => false, :null => false
      t.column :deleted_at, :timestamp
      t.column :ts, :timestamp, :null => false
    end
    add_index :money_transactions, :deleted_at
  end

  def self.down
    drop_table :money_transactions
  end
end
