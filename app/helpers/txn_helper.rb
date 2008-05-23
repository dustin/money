module TxnHelper

  def make_txn_checkbox_callback(tid, acct, checked)
    remote_function :url => {
      :controller => 'txn', :action => 'set_reconcile', :id => tid,
      :acct_id => acct.id, :checked => checked }
  end

end
