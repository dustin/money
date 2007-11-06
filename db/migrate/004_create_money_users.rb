class CreateMoneyUsers < ActiveRecord::Migration
  def self.up
    create_table :money_users do |t|
    end
  end

  def self.down
    drop_table :money_users
  end
end
