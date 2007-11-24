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