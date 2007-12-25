class AcctController < ApplicationController
  include AcctHelper

  def index
    @groups=current_user.groups
    @tasks=AllowanceTask.find_available current_user
  end

  # Get the categories available for the given account ID
  def cats_for_acct
    acct = MoneyAccount.find(params[:id].to_i)
    render :text => acct.group.categories.to_json, :layout => false
  end

end
