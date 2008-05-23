class TxnController < ApplicationController
  include TxnHelper

  # The maximum number of transactions that will be displayed
  TXN_LIMIT=50 unless defined? TXN_LIMIT
  BIG_LIMIT=100000 unless defined? BIG_LIMIT

  before_filter :find_acct

  def index
    case params[:which]
    when nil
      do_txn_page :find
      title "Full transaction list for #{@current_acct.name}"
    when 'unreconciled'
      do_txn_page :find, BIG_LIMIT, default_conditions.merge(:reconciled => false)
      title "Unreconciled transaction list for #{@current_acct.name}"
    when 'all'
      do_txn_page :find_with_deleted
      title "Full transaction list for #{@current_acct.name} (including deleted)"
    end
    @type = :normal
  end

  def new
    setup_form_vars
    title "New Transaction in #{@current_acct.name}"
  end

  def create
    setup_form_vars
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
    redirect_to new_acct_txn_path(@current_acct)
  end

  def update
    @txn = MoneyTransaction.find params[:id]
    case params[:f]
    when 'reconciled'
      @txn.reconciled = (params[:value].to_i == 1)
    when 'descr'
      @txn.descr = params[:value]
    when 'cat'
      @txn.category = Category.find_by_name_and_group_id params[:value], @txn.account.group.id
    else
      raise "Unhandled field:  #{params[:f]}"
    end
    @txn.save!
    render :text => params[:value]
  end

  def current_reconciled
    get_sums
    render :template => 'txn/update_reconciled'
  end

  private

  def setup_form_vars
    @today = Date.today.strftime
    @categories=@current_acct.group.categories
    @txn = MoneyTransaction.new(params[:money_transaction])
  end

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
    { :money_account_id => @current_acct }
  end

  def find_acct
    if @current_acct.nil?
      @current_acct=MoneyAccount.find params[:acct_id]
      @current_group=@current_acct.group
    end
  end

  # Load up some transactions with the approriate transaction find method
  def do_txn_page(which, limit=TXN_LIMIT, list_conditions=nil, conditions=nil)
    conditions = conditions.nil? ? default_conditions : conditions
    list_conditions = list_conditions.nil? ? default_conditions : list_conditions
    get_sums conditions
    @transactions=MoneyTransaction.send which, :all,
      :conditions => list_conditions, :order => "money_transactions.ds desc, money_transactions.id desc",
      :limit => limit, :include => [:user, :category]
  end

end
