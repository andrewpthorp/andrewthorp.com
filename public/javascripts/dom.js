(function() {
  var delay,
    __slice = [].slice;

  delay = function() {
    var args, fn, time;
    time = arguments[0], fn = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
    return setTimeout.apply(null, [fn, time].concat(__slice.call(args)));
  };

  $(function() {
    return $(document).foundation();
  });

}).call(this);
