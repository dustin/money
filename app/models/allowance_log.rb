# == Schema Information
# Schema version: 9
#
# Table name: allowance_logs
#
#  id                :integer       not null, primary key
#  allowance_task_id :integer       not null
#  ts                :datetime      not null
#

class AllowanceLog < ActiveRecord::Base
  belongs_to :allowance_task, :class_name => "AllowanceTask", :foreign_key => "allowance_task_id"

  class << self
    def find_latest(task)
      find :first, :conditions => ["allowance_task_id = ?", task.id],
        :order => "ts desc"
    end
  end
end
