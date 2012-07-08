(function() {

  jQuery(function($) {
    var Twitter;
    Twitter = {
      settings: {
        count: 1,
        url: "https://api.twitter.com/1/statuses/user_timeline.json?callback=?"
      },
      init: function(config) {
        if (config.container === []) {
          return false;
        }
        this.settings = $.extend(this.settings, config);
        return this.fetch();
      },
      attachTemplate: function() {
        var temp;
        temp = Handlebars.compile(this.settings.template);
        this.settings.container.append(temp(this.tweet));
        return this.settings.container.removeClass("hidden");
      },
      attachError: function() {
        var temp;
        if (this.settings.errorTemplate !== void 0) {
          temp = Handlebars.compile(this.settings.errorTemplate);
          return this.settings.container.append(temp());
        } else {
          return this.settings.container.hide();
        }
      },
      linkify: function(text) {
        text = text.replace(/(https?:\/\/\S+)/gi, function(s) {
          return "<a href='" + s + "'>" + s + "</a>";
        });
        text = text.replace(/(^|)@(\w+)/gi, function(s) {
          return "<a href='http://twitter.com/" + s + "'>" + s + "</a>";
        });
        text = text.replace(/(^|)#(\w+)/gi, function(s) {
          return "<a href='http://search.twitter.com/search?q=" + (s.replace(/#/, '%23')) + "'>" + s + "</a>";
        });
        return text;
      },
      fetch: function() {
        var self;
        self = this;
        return $.ajax({
          url: this.settings.url,
          dataType: 'jsonp',
          data: {
            screen_name: self.settings.username,
            count: self.settings.count
          },
          success: function(data) {
            self.tweet = {
              text: self.linkify(data[0].text),
              time: $.timeago(data[0].created_at)
            };
            return self.attachTemplate();
          },
          timeout: 5000,
          error: function(jqXHR, textStatus, errorThrown) {
            return self.attachError();
          }
        });
      }
    };
    $(function() {
      return Twitter.init({
        template: $("#tweet-template").html(),
        errorTemplate: $("#tweet-error-template").html(),
        container: $(".tweet-list"),
        username: "andrewpthorp",
        count: 1
      });
    });
    return true;
  });

}).call(this);
