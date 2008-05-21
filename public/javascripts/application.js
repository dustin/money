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
    var url="/acct/cats_for_acct/" + acct;
    new Ajax.Request(url, {method: 'get',
        onSuccess: function(req) {
            clear_children(listel);
            var json=eval(req.responseText);
            $A(json).each(function(i) {
                var o=document.createElement("option");
                o.value=i.attributes.id;
                o.appendChild(document.createTextNode(i.attributes.name));
                listel.appendChild(o);
            });
        }
    });
}