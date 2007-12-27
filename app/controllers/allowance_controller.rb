class AllowanceController < ApplicationController

  def created
    title "Allowance Tasks You've Created"
    @tasks=AllowanceTask.find_all_by_creator_id current_user.id, :order => 'name'
  end

  def new
    title "Create an allowance task"
    @users=User.find :all, :conditions => ["id != ?", current_user.id], :order => 'name'
    @accounts = Hash.new {|h,k| h[k] = []}
    MoneyAccount.find(:all, :conditions => ["active = ?", true], :order => 'name').each do |a|
      if current_user.groups.include? a.group
        @accounts[a.group_id] << a
      end
    end
    @categories = Hash.new {|h,k| h[k] = []}
    Category.find(:all, :order => 'name').each do |c|
      if current_user.groups.include? c.group
        @categories[c.group_id] << c
      end
    end
    @groups = current_user.groups

    if request.post?
      @task=AllowanceTask.new params[:allowance_task]
      @task.creator = current_user
      @task.save!
      flash[:info] = "Created new task:  #{@task.name}"
      redirect_to :action => :created
    end
  end

  # Toggle the active state of a task
  def task_toggle
    task=AllowanceTask.find params[:id].to_i
    active = (params[:active] == 'true')
    task.deleted = !active
    task.save!
    render :action => (active ? :activate : :deactivate)
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
