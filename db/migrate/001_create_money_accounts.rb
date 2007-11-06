class CreateMoneyAccounts < ActiveRecord::Migration
  def self.up
    create_table :money_accounts do |t|
    end
  end

  def self.down
    drop_table :money_accounts
  end
end
