$ ->
  $form = $("form#login")
  delay = (ms, func) -> setTimeout func, ms

  $("form#login input[type=password]").keyup ->
    $this = $(@)

    if $this.val() == ""
      $this.removeClass "success error"

    else
      $.post "/sessions/create?#{$form.serialize()}", (data) =>
        if data.success
          $this.addClass "success"
          delay 250, ->
            window.location.href = data.return
        else
          $this.addClass "error"

