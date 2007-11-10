class CreateAllowanceLogs < ActiveRecord::Migration
  def self.up
    create_table :allowance_logs do |t|
      t.column :allowance_task_id, :integer, :null => false
      t.column :ts, :timestamp, :null => false
    end
  end

  def self.down
    drop_table :allowance_logs
  end
end
