class CreateMoneyRoles < ActiveRecord::Migration
  def self.up
    create_table :money_roles do |t|
    end
  end

  def self.down
    drop_table :money_roles
  end
end
