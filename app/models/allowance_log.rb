class AllowanceLog < ActiveRecord::Base
  belongs_to :allowance_task, :class_name => "AllowanceTask", :foreign_key => "allowance_task_id"

  class << self
    def find_latest(task)
      find :first, :conditions => ["allowance_task_id = ?", task.id],
        :order => "ts desc"
    end

    def find_all_latest(owner)
      find :all, :include => {:allowance_task => {}},
        :conditions => ["allowance_tasks.owner_id = ?", owner.id],
        :order => "ts desc", :group => "allowance_task_id"
    end
  end
end
