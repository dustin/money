class AllowanceController < ApplicationController

  def created
    @tasks=AllowanceTask.find_all_by_creator_id current_user.id, :order => 'name'
  end

  def complete
    tids = params['task'].keys.map(&:to_i)
    # To prevent fraud, only include task IDs from those available.
    available = AllowanceTask.find_available(current_user)
    tasks = available.find_all {|n| tids.include? n.id}
    AllowanceTask.transaction do
      tasks.each {|t| t.perform!}
    end
    redirect_to :controller => 'acct', :action => 'index'
  end

end
