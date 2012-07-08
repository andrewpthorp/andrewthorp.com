$ ->
  $("#global-nav li").hover ->
    $("#masthead").toggleClass("blog portfolio resume about", false)
    $("#masthead").addClass($(this).data("masthead"))
