class AcctController < ApplicationController
  include AcctHelper

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
    if request.post?
      # Force some fields
      @txn.user = current_user
      @txn.account = @current_acct
      @txn.ts = Time.now
      # Weird amount handling to make the difference between deposit and withdrawal clear
      @txn.amount = @txn.amount.abs
      if params[:withdraw].to_i == 1
        @txn.amount = 0 - @txn.amount
      end
      @txn.save!
      flash[:info]="Saved txn for #{@txn.amount}"
      @new_id = @txn.id
      redirect_to :action => 'new'
    end
  end

  def transfer
    @today = Date.today.strftime
    @current_acct=MoneyAccount.find(params[:id].to_i)
    @categories=@current_acct.group.categories

    if request.post?
      dest_acct_id=params[:dest_acct].to_i
      if @current_acct.id == dest_acct_id
        flash[:error]="Source and destination accounts must be different."
        redirect_to :action => 'transfer'
      else
        # Do stuff
        dest_acct=MoneyAccount.find dest_acct_id
        src_cat=Category.find(params[:dest_cat].to_i)
        dest_cat=Category.find(params[:src][:category_id].to_i)

        details=params[:details]
        amt=details[:amount].to_f

        do_transfer(current_user, @current_acct,
          dest_acct, src_cat, dest_cat, details[:ds], amt, details[:descr])

        flash[:info]="Transferred #{amt} from #{@current_acct.name} to #{dest_acct.name}"
        redirect_to :action => 'transfer'
      end
    end
  end

  # Get the categories available for the given account ID
  def cats_for_acct
    acct = MoneyAccount.find(params[:id].to_i)
    render :text => acct.group.categories.to_json, :layout => false
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
