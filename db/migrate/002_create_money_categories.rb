class CreateMoneyCategories < ActiveRecord::Migration
  def self.up
    create_table :money_categories do |t|
    end
  end

  def self.down
    drop_table :money_categories
  end
end
