class CreateMoneyTransactions < ActiveRecord::Migration
  def self.up
    create_table :money_transactions do |t|
    end
  end

  def self.down
    drop_table :money_transactions
  end
end
