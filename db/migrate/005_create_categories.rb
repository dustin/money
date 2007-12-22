class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :group_id, :integer, :null => false
      t.column :name, :string, :null => false
      t.column :budget, :decimal, :precision => 9, :scale => 2, :null => true
    end
    add_index :categories, [:group_id, :name], :unique => true
  end

  def self.down
    drop_table :categories
  end
end
