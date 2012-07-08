(function() {

  $(function() {
    return $("#global-nav li").hover(function() {
      $("#masthead").toggleClass("blog portfolio resume about", false);
      return $("#masthead").addClass($(this).data("masthead"));
    });
  });

}).call(this);
