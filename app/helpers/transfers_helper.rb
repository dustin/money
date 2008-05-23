module TransfersHelper

  def do_transfer(user, srcacct, destacct, srccat, destcat, ds, amt, descr, srcuser=nil)
    raise "Can't transfer within an account." if srcacct == destacct
    raise "Must transfer a positive amount." unless amt > 0

    # Optionally accept a different user for the source account.
    srcuser = user if srcuser == nil

    txn1=make_txn srcuser, srcacct, srccat, ds, 0 - amt.abs, "Transfer to #{destacct.name} (#{descr})"
    txn2=make_txn user, destacct, destcat, ds, amt.abs, "Transfer from #{srcacct.name} (#{descr})"

    MoneyTransaction.transaction do
      txn1.save!
      txn2.save!
    end

    [txn1, txn2]
  end

  private

  def make_txn(user, acct, cat, ds, amt, descr)
    MoneyTransaction.new :category_id => cat.id, :ds => ds, :amount => amt, :descr => descr,
      :money_account_id => acct.id, :ts => Time.now, :user_id => user.id
  end

end
