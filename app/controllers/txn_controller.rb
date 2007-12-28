class TxnController < ApplicationController
  include TxnHelper

  # The maximum number of transactions that will be displayed
  TXN_LIMIT=50
  BIG_LIMIT=100000

  def index
    do_txn_page :find
    @type = :normal
    title "Full transaction list for #{@current_acct.name}"
  end

  def unreconciled
    get_acct_from_params
    do_txn_page :find, BIG_LIMIT, ["money_account_id = ? and reconciled = ?", @current_acct.id, false]
    @type = :unreconciled
    title "Unreconciled transaction list for #{@current_acct.name}"
    render :template => "txn/index"
  end

  def all
    do_txn_page :find_with_deleted
    @type = :all
    title "Full transaction list for #{@current_acct.name} (including deleted)"
    render :template => "txn/index"
  end

  def new
    @today = Date.today.strftime
    @current_acct=MoneyAccount.find(params[:id].to_i)
    @categories=@current_acct.group.categories
    @txn = MoneyTransaction.new(params[:money_transaction])

    title "New Transaction in #{@current_acct.name}"

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

    title "Transfer from #{@current_acct.name}"

    if request.post?
      dest_acct_id=params[:dest_acct].to_i
      if @current_acct.id == dest_acct_id
        flash[:error]="Source and destination accounts must be different."
        redirect_to :action => 'transfer'
      else
        # Do stuff
        dest_acct=MoneyAccount.find dest_acct_id
        dest_cat=Category.find(params[:dest_cat].to_i)
        src_cat=Category.find(params[:src][:category_id].to_i)

        details=params[:details]
        amt=details[:amount].to_f

        do_transfer(current_user, @current_acct,
          dest_acct, src_cat, dest_cat, details[:ds], amt, details[:descr])

        flash[:info]="Transferred #{amt} from #{@current_acct.name} to #{dest_acct.name}"
        redirect_to :action => 'transfer'
      end
    end
  end

  def set_reconcile
    get_acct_from_params
    @txn = MoneyTransaction.find params[:id].to_i
    @txn.reconciled = (params[:checked].to_i == 1)
    @txn.save!
    get_sums
    render :template => 'txn/update_reconciled'
  end

  private

  def get_sums(conditions=nil)
    conditions = conditions.nil? ? default_conditions : conditions
    @txn_sum=MoneyTransaction.sum(:amount, :conditions => conditions) || 0
    rec_conditions=["money_account_id = ? and reconciled=?", @current_acct.id]
    @rec_sum=MoneyTransaction.sum(:amount,
      :conditions => rec_conditions + [true]) || 0
    @unrec_sum=MoneyTransaction.sum(:amount,
      :conditions => rec_conditions + [false]) || 0
  end

  def default_conditions
    ["money_account_id = ?", @current_acct.id]
  end

  def get_acct_from_params
    if @current_acct.nil?
      id = params[:acct_id] || params[:id]
      @current_acct=MoneyAccount.find id.to_i
    end
  end

  # Load up some transactions with the approriate transaction find method
  def do_txn_page(which, limit=TXN_LIMIT, list_conditions=nil, conditions=nil)
    get_acct_from_params
    conditions = conditions.nil? ? default_conditions : conditions
    list_conditions = list_conditions.nil? ? default_conditions : list_conditions
    get_sums conditions
    @transactions=MoneyTransaction.send which, :all,
      :conditions => list_conditions, :order => "money_transactions.ds desc, money_transactions.id desc",
      :limit => limit, :include => [:user, :category]
  end

end
