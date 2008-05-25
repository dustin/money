// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function field_blur_behavior(field, def) {
    var f=$(field);
        var defaultClass='defaultfield';
    f.onfocus=function() {
        if(f.value === def) {
            f.value='';
            Element.removeClassName(f, defaultClass);
        }
    };
    f.onblur=function() {
        if(f.value === '') {
            f.value=def;
            Element.addClassName(f, defaultClass);
        }
    };
        Event.observe(window, 'unload', f.onfocus);
    f.onblur();
}

// Remove all children from the given element.
function clear_children(el) {
    while(el.hasChildNodes()) {
        el.removeChild(el.firstChild);
    }
}

// Load the categories applicable to the given account
// into the given select list element.
function load_cats_for_acct(acct, listel) {
    listel=$(listel);
    var url="/categories?acct_id=" + acct;
    new Ajax.Request(url, {method: 'get',
        onSuccess: function(req) {
            clear_children(listel);
            var json=eval(req.responseText);
            $A(json).each(function(i) {
                var o=document.createElement("option");
                o.value=i.id;
                o.appendChild(document.createTextNode(i.name));
                listel.appendChild(o);
            });
        }
    });
}

// Set up transaction editors in places that have transaction lists.
// Requires a variable called ``known_cats'' to contain an array of cat names
function setup_txn_reconcile(acct_id, id, recSuccess) {
    $('txn_' + id).onclick=function() {
      var checked = ($('txn_' + id).checked) ? 1 : 0;
      new Ajax.Request('/acct/' + acct_id + '/txn/' + id + "?f=reconciled&value=" + checked, {
        method: "put",
        onSuccess: recSuccess
      });
    }
}
function setup_txn_editors(aid, id, cats, recSuccess) {
    if(recSuccess) {
        setup_txn_reconcile(aid, id, recSuccess);
    }
    new Ajax.InPlaceEditor('txn_desc_' + id, '/acct/' + aid + '/txn/' + id + '?f=descr&_method=put');
    new Ajax.InPlaceCollectionEditor('txn_cat_' + id,
        '/acct/' + aid + '/txn/' + id + '?f=cat&_method=put', {
            collection: cats
    });
}
