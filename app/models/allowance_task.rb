# == Schema Information
# Schema version: 9
#
# Table name: allowance_tasks
#
#  id                    :integer       not null, primary key
#  name                  :string(64)    not null
#  description           :text          not null
#  creator_id            :integer       not null
#  owner_id              :integer       not null
#  frequency             :integer       not null
#  value                 :decimal(6, 2) not null
#  from_money_account_id :integer       not null
#  to_money_account_id   :integer       not null
#  from_category_id      :integer       not null
#  to_category_id        :integer       not null
#  deleted               :boolean       
#

class AllowanceTask < ActiveRecord::Base
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
  belongs_to :from_account, :class_name => "MoneyAccount", :foreign_key => "from_money_account_id"
  belongs_to :to_account, :class_name => "MoneyAccount", :foreign_key => "to_money_account_id"
  belongs_to :from_category, :class_name => "Category", :foreign_key => "from_category_id"
  belongs_to :to_category, :class_name => "Category", :foreign_key => "to_category_id"

  def validate
    unless creator.groups.include?(from_account.group)
      errors.add("creator", "#{creator.login} has no permission to account #{from_account.id}")
    end
    unless owner.groups.include?(to_account.group)
      errors.add("owner", "#{owner.login} has no permission to account #{to_account.id}")
    end
    unless from_account.group_id == from_category.group_id
      errors.add("category", "#{from_category.id} does not belong to account #{from_account.id}")
    end
    unless to_account.group_id == to_category.group_id
      errors.add("category", "#{to_category.id} does not belong to account #{to_account.id}")
    end
    unless value > 0
      errors.add "value", "should be greater than zero"
    end
    unless frequency > 0
      errors.add "frequency", "should be greater than zero"
    end
  end

  # Perform this task.
  def perform!
    fromuser = User.find creator_id
    touser = User.find owner_id
    srcacct = MoneyAccount.find from_money_account_id
    destacct = MoneyAccount.find to_money_account_id
    srccat = Category.find from_category_id
    destcat = Category.find to_category_id
    ds = Date.today
    amt = value
    descr = "Completed task #{name}"
    AllowanceLog.transaction do
      do_transfer(touser, srcacct, destacct, srccat, destcat, ds, amt, descr, fromuser)
      AllowanceLog.create :allowance_task_id => id, :ts => Time.now
    end
  end

  class << self

    # Find tasks available for the given user.
    def find_available(user)
      # I originally did this with a :joins and :conditions, but AR got pissed
      find_by_sql available_query(user)
    end

  end

  private

  include TxnHelper

  def AllowanceTask.available_query(user)
    query=<<ENDSQL
select *
    from allowance_tasks 
        left outer join (
            select allowance_task_id, max(ts) as ts from allowance_logs
                group by allowance_task_id) logs
            on (logs.allowance_task_id = id)
        where
            owner_id = #{user.id}
            and deleted = false
            and (logs.ts is null or date(logs.ts) + frequency <= current_date)
        order by name
ENDSQL
  end
  
end
