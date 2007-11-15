class AcctController < ApplicationController

  TXN_LIMIT=50

  def index
    @groups=current_user.groups
  end

  def transactions
    do_txn_page :find
  end

  def transactions_all
    do_txn_page :find_with_deleted
    render :template => "acct/transactions"
  end

  def recent
    @transactions=MoneyTransaction.find_with_deleted :all,
      :order => "ts desc", :limit => TXN_LIMIT
  end

  private

    # Load up some transactions with the approriate transaction find method
    def do_txn_page(which)
      @current_acct=MoneyAccount.find(params[:id].to_i)
      conditions=["money_account_id = ?", @current_acct.id]

      @transactions=MoneyTransaction.send which, :all,
        :conditions => conditions, :order => "ts desc", :limit => TXN_LIMIT

      @txn_sum=MoneyTransaction.sum(:amount, :conditions => conditions) || 0
      rec_conditions=["money_account_id = ? and reconciled=?", @current_acct.id]
      @rec_sum=MoneyTransaction.sum(:amount,
        :conditions => rec_conditions + [true]) || 0
      @unrec_sum=MoneyTransaction.sum(:amount,
        :conditions => rec_conditions + [false]) || 0
    end

end
