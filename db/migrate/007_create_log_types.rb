class CreateLogTypes < ActiveRecord::Migration
  def self.up
    create_table :log_types do |t|
    end
  end

  def self.down
    drop_table :log_types
  end
end
