
/*
 # Keyboard Shortcuts
 #
 # This is where I specify all of my keyboard shortcuts.
 # An example would be "/admin", "/admin/posts/new", etc.
 #
 # @author Andrew Thorp
*/


(function() {

  $(function() {
    var $doc;
    $doc = $(document);
    return $(document).bind("keydown", function(e) {
      var loc;
      if (e.ctrlKey && e.keyCode === 65) {
        return window.location.href = "/admin";
      } else if (e.ctrlKey && e.keyCode === 78) {
        return window.location.href = "/admin/posts/new";
      } else if (e.ctrlKey && e.keyCode === 69) {
        loc = window.location.href.match(/posts\/(.+)/);
        if (loc !== null) {
          return window.location.href = "/admin/posts/" + loc[1] + "/edit";
        }
      }
    });
  });

}).call(this);
