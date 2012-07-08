(function() {

  jQuery(function($) {
    var Instagram;
    Instagram = {
      settings: {
        endpoint: 'https://api.instagram.com/v1',
        accessToken: '6074984.66b853b.1ec7891744b24193b70fa99646189e2a',
        count: 20
      },
      init: function(config) {
        if (config.container === []) {
          return false;
        }
        this.settings = $.extend(this.settings, config);
        this.settings.url = "" + this.settings.endpoint + "/users/" + this.settings.userId + "/media/recent?callback=?";
        return this.fetch();
      },
      attachTemplate: function() {
        var temp;
        temp = Handlebars.compile(this.settings.template);
        return this.settings.container.append(temp(this.images));
      },
      fetch: function() {
        var self;
        self = this;
        return $.getJSON(this.settings.url, {
          access_token: self.settings.accessToken,
          count: self.settings.count
        }, function(results) {
          self.images = $.map(results.data, function(data) {
            return {
              image: data.images.low_resolution.url,
              link: data.link
            };
          });
          return self.attachTemplate();
        });
      }
    };
    $(function() {
      return Instagram.init({
        template: $("#instagram-template").html(),
        container: $(".instagram"),
        userId: "6074984"
      });
    });
    return true;
  });

}).call(this);
