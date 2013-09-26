(function() {
  define(function(require) {
    var Backbone, MainRouter, Views, config, configData;
    Backbone = require('backbone');
    MainRouter = require('routers/main');
    configData = require('models/configdata');
    config = require('config');
    Views = {
      Header: require('views/ui/header')
    };
    return {
      initialize: function() {
        var _this = this;
        configData.fetch({
          success: function() {
            var header, mainRouter;
            mainRouter = new MainRouter();
            header = new Views.Header({
              managed: false,
              title: configData.get('title')
            });
            $('header.wrapper').prepend(header.$el);
            Backbone.history.start({
              root: config.basePath || '',
              pushState: true
            });
            return $(document).on('click', 'a:not([data-bypass])', function(e) {
              var href;
              href = $(this).attr('href');
              if (href != null) {
                e.preventDefault();
                return Backbone.history.navigate(href, {
                  trigger: true
                });
              }
            });
          }
        });
        return {
          error: function() {
            return console.log("Could not fetch config data");
          }
        };
      }
    };
  });

}).call(this);
