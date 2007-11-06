class CreateAllowanceTasks < ActiveRecord::Migration
  def self.up
    create_table :allowance_tasks do |t|
    end
  end

  def self.down
    drop_table :allowance_tasks
  end
end
