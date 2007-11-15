class AcctController < ApplicationController

  def index
    @groups=current_user.groups
  end

  def transactions
    @current_acct=MoneyAccount.find(@params[:id].to_i)
  end

end
