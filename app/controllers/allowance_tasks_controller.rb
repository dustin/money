class AllowanceTasksController < ApplicationController

  def index
    title "Allowance Tasks You've Created"
    @tasks=AllowanceTask.find_all_by_creator_id(current_user.id,
      :order => 'allowance_tasks.name', :include => :owner).group_by(&:owner)
    @weekly_sums = {}
    @tasks.each do |owner,tasks|
      @weekly_sums[owner] = tasks.reject(&:deleted).inject(0.0) {|c,i| c + i.weekly_value}
    end
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
  end

  def create
    @task=AllowanceTask.new params[:allowance_task]
    @task.creator = current_user
    @task.save!
    flash[:info] = "Created new task:  #{@task.name}"
    redirect_to allowance_tasks_path
  end

  # Toggle the active state of a task
  def update
    if params[:active]
      update_status
    elsif params[:task]
      update_completion
    else
      raise "Don't know what you want"
    end
  end

  private

  def update_status
    task=AllowanceTask.find params[:id].to_i
    active = (params[:active] == 'true')
    task.deleted = !active
    task.save!
    render :action => (active ? :activate : :deactivate)
  end

  def update_completion
    tids = params['task'].keys.map(&:to_i)
    # To prevent fraud, only include task IDs from those available.
    available = AllowanceTask.find_available(current_user)
    tasks = available.find_all {|n| tids.include? n.id}
    AllowanceTask.transaction do
      tasks.each {|t| t.perform!}
    end
    redirect_to home_path
  end

end
