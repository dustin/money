class MoneyAccountsController < ApplicationController
  include AcctHelper

  def index
    @groups=current_user.groups
    @tasks=AllowanceTask.find_available current_user
  end

  def new
    @groups=current_user.groups
  end

  def create
    acct = MoneyAccount.new params[:money_account]
    acct.group = Group.find params[:money_account][:group_id]
    acct.active = true
    raise "Access denied" unless current_user.groups.include? acct.group
    acct.save!
    redirect_to home_path
  end

end
