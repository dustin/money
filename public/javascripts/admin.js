function mk_txn_onlick_handler(tid) {
  return function() {
    var action = 'undelete';
    if($("txn_" + tid).checked) {
      action = 'delete';
    }
    new Ajax.Request('/adm/' + action + '/' + tid, {evalScripts: true});
    return true;
  }
}