class AcctController < ApplicationController
  include AcctHelper

  def index
    @groups=current_user.groups
  end

  # Get the categories available for the given account ID
  def cats_for_acct
    acct = MoneyAccount.find(params[:id].to_i)
    render :text => acct.group.categories.to_json, :layout => false
  end

end
