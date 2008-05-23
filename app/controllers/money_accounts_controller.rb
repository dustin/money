class MoneyAccountsController < ApplicationController
  include AcctHelper

  def index
    @groups=current_user.groups
    @tasks=AllowanceTask.find_available current_user
  end

end
