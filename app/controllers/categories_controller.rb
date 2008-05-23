class CategoriesController < ApplicationController

  # Get the categories available for the given account ID
  def index
    acct = MoneyAccount.find(params[:acct_id].to_i)
    render :text => acct.group.categories.sort.to_json, :layout => false
  end

end
