jQuery ($) ->

  Twitter =
    settings:
      count: 1
      url: "https://api.twitter.com/1/statuses/user_timeline.json?callback=?"

    init: (config) ->
      return false if config.container == []
      this.settings = $.extend(this.settings, config)
      this.fetch()

    attachTemplate: () ->
      temp = Handlebars.compile this.settings.template
      this.settings.container.append temp(this.tweet)
      this.settings.container.removeClass "hidden"

    attachError: () ->
      if (this.settings.errorTemplate != undefined)
        temp = Handlebars.compile this.settings.errorTemplate
        this.settings.container.append temp()
      else
        this.settings.container.hide()

    linkify: (text) ->
      text = text.replace /(https?:\/\/\S+)/gi, (s) -> return "<a href='#{s}'>#{s}</a>"
      text = text.replace /(^|)@(\w+)/gi, (s) -> return "<a href='http://twitter.com/#{s}'>#{s}</a>"
      text = text.replace /(^|)#(\w+)/gi, (s) -> return "<a href='http://search.twitter.com/search?q=#{s.replace(/#/,'%23')}'>#{s}</a>"
      return text

    fetch: () ->
      self = this

      $.ajax
        url: this.settings.url
        dataType: 'jsonp'
        data:
          screen_name: self.settings.username
          count: self.settings.count
        success: (data) ->
          self.tweet =
            text: self.linkify(data[0].text),
            time: $.timeago(data[0].created_at)
          self.attachTemplate()
        timeout: 5000
        error: (jqXHR, textStatus, errorThrown) ->
          self.attachError()


  # Fire it off!
  $ ->
    Twitter.init
      template: $("#tweet-template").html()
      errorTemplate: $("#tweet-error-template").html()
      container: $(".tweet-list")
      username: "andrewpthorp"
      count: 1

  # Prevent the document.ready function from returning
  return true
