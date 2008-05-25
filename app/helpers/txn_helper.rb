module TxnHelper

  def make_txn_checkbox_callback(tid, acct, checked)
    remote_function :url => {
      :controller => 'txn', :action => 'set_reconcile', :id => tid,
      :acct_id => acct.id, :checked => checked }
  end

  def txn_delete_tag(txn)
    link_to_remote(tag("img", {:src => '/images/trash.gif', :class => 'trash', :alt => '[delete]'}),
      :url => formatted_acct_txn_path(txn.account, txn, 'js'), :method => :delete)
  end

end
