jQuery ($) ->

  Instagram =
    settings:
      endpoint: 'https://api.instagram.com/v1'
      accessToken: '6074984.66b853b.1ec7891744b24193b70fa99646189e2a'
      count: 20

    init: (config) ->
      return false if config.container == []
      this.settings = $.extend(this.settings, config)
      this.settings.url = "#{this.settings.endpoint}/users/#{this.settings.userId}/media/recent?callback=?"
      this.fetch()

    attachTemplate: () ->
      temp = Handlebars.compile(this.settings.template)
      this.settings.container.append( temp(this.images) )


    fetch: () ->
      self = this

      $.getJSON this.settings.url,

        {
          access_token: self.settings.accessToken
          count: self.settings.count
        },

        (results) ->
          self.images = $.map results.data, (data) ->
            return {
              image: data.images.low_resolution.url
              link: data.link
            }

          self.attachTemplate()


  # Fire It Off!
  $ ->
    Instagram.init
      template: $("#instagram-template").html(),
      container: $(".instagram"),
      userId: "6074984"

  return true
