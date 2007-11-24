class AcctController < ApplicationController

  # The maximum number of transactions that will be displayed
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

  def new
    @today = Date.today.strftime
    @current_acct=MoneyAccount.find(params[:id].to_i)
    @categories=@current_acct.group.categories
    @txn = MoneyTransaction.new(params[:money_transaction])
    # Force some fields
    @txn.user = current_user
    @txn.account = @current_acct
    @txn.ts = Time.now
    if request.post?
      # Weird amount handling to make the difference between deposit and withdrawal clear
      @txn.amount = @txn.amount.abs
      if params[:withdraw].to_i == 1
        @txn.amount = 0 - @txn.amount
      end
      @txn.save!
      flash[:saved]="Saved txn for #{@txn.amount}"
      redirect_to :action => 'new'
    end
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
