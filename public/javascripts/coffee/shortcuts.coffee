###
 # Keyboard Shortcuts
 #
 # This is where I specify all of my keyboard shortcuts.
 # An example would be "/admin", "/admin/posts/new", etc.
 #
 # @author Andrew Thorp
###
$ ->
  $doc = $(document)

  $(document).bind "keydown", (e) ->

    if (e.ctrlKey && e.keyCode == 65)
      window.location.href = "/admin"

    else if (e.ctrlKey && e.keyCode == 78)
      window.location.href = "/admin/posts/new"

    else if (e.ctrlKey && e.keyCode == 69)
      loc = window.location.href.match(/posts\/(.+)/)
      if (loc != null)
        window.location.href = "/admin/posts/#{loc[1]}/edit"
