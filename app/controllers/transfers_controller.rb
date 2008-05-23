class TransfersController < ApplicationController

  include TransfersHelper

  before_filter :find_acct

  def new
    @today = Date.today.strftime
    @categories=@current_acct.group.categories

    title "Transfer from #{@current_acct.name}"
  end

  def create
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

  private

  def find_acct
    if @current_acct.nil?
      @current_acct=MoneyAccount.find params[:acct_id]
      @current_group=@current_acct.group
    end
  end

end
