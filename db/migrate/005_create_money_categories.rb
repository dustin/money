class CreateMoneyCategories < ActiveRecord::Migration
  def self.up
    create_table :money_categories do |t|
      t.column :money_group_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :budget, :decimal, :precision => 6, :scale => 2, :null => true
    end
    add_index :money_categories, [:money_group_id, :name], :unique => true
  end

  def self.down
    drop_table :money_categories
  end
end
