class CreateMoneyTransactions < ActiveRecord::Migration
  def self.up
    create_table :money_transactions do |t|
      t.column :money_user_id, :integer, :null => false
      t.column :money_account_id, :integer, :null => false
      t.column :money_category_id, :integer, :null => false
      t.column :descr, :string, :null => false
      t.column :amount, :decimal, :precision => 6, :scale => 2, :null => false
      t.column :ds, :date, :null => false
      t.column :reconciled, :boolean, :default => false, :null => false
      t.column :deleted, :boolean, :default => false, :null => false
      t.column :ts, :timestamp, :null => false
    end
  end

  def self.down
    drop_table :money_transactions
  end
end
