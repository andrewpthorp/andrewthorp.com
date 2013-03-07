(function() {

  $(function() {
    var $form, delay;
    $form = $("form#login");
    delay = function(ms, func) {
      return setTimeout(func, ms);
    };
    return $("form#login input[type=password]").keyup(function() {
      var $this,
        _this = this;
      $this = $(this);
      if ($this.val() === "") {
        return $this.removeClass("success error");
      } else {
        return $.post("/sessions/create?" + ($form.serialize()), function(data) {
          if (data.success) {
            $this.addClass("success");
            return window.location.href = data["return"];
          } else {
            return $this.addClass("error");
          }
        });
      }
    });
  });

}).call(this);
