class CreateMoneyGroups < ActiveRecord::Migration
  def self.up
    create_table :money_groups do |t|
    end
  end

  def self.down
    drop_table :money_groups
  end
end
