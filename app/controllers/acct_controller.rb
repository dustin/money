class AcctController < ApplicationController
  def transactions
    @current_acct=MoneyAccount.find(@params[:id].to_i)
  end
end
