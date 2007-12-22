class CreateAllowanceTasks < ActiveRecord::Migration
  def self.up
    create_table :allowance_tasks do |t|
      t.column :name, :string, :limit => 64, :null => false
      t.column :description, :text, :null => false
      t.column :creator_id, :integer, :null => false
      t.column :owner_id, :integer, :null => false
      t.column :frequency, :integer, :null => false
      t.column :value, :decimal, :precision => 9, :scale => 2, :null => false
      t.column :from_money_account_id, :integer, :null => false
      t.column :to_money_account_id, :integer, :null => false
      t.column :from_category_id, :integer, :null => false
      t.column :to_category_id, :integer, :null => false
      t.column :deleted, :boolean, :default => false
    end
    add_index :allowance_tasks, :owner_id
    add_index :allowance_tasks, :from_money_account_id
  end

  def self.down
    drop_table :allowance_tasks
  end
end
