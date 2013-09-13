# delay - makes working with setTimeout in CoffeeScript much easier.
delay = (time, fn, args...) ->
  setTimeout fn, time, args...

$ ->
  $(document).foundation()
