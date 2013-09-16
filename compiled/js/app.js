(function() {
  define(function(require) {
    var Backbone, MainRouter, Views, configData;
    Backbone = require('backbone');
    MainRouter = require('routers/main');
    configData = require('models/configdata');
    Views = {
      Header: require('views/ui/header')
    };
    return {
      initialize: function() {
        var _this = this;
        return configData.fetch({
          success: function() {
            var header, mainRouter;
            mainRouter = new MainRouter();
            header = new Views.Header({
              managed: false,
              title: configData.get('title')
            });
            $('header.wrapper').prepend(header.$el);
            Backbone.history.start({
              root: window.location.pathname,
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
      }
    };
  });

}).call(this);
