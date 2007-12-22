class AccountActiveFlag < ActiveRecord::Migration
  def self.up
    add_column :money_accounts, :active, :boolean
    MoneyAccount.find(:all).each do |a|
      a.active = true
      a.save!
    end
  end

  def self.down
    remove_column :money_accounts, :active
  end
end
