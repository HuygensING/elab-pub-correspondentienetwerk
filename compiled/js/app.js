(function() {
  define(function(require) {
    var Backbone, MainRouter, Views;
    Backbone = require('backbone');
    MainRouter = require('routers/main');
    Views = {
      Header: require('views/ui/header')
    };
    return {
      initialize: function() {
        var header, mainRouter;
        mainRouter = new MainRouter();
        header = new Views.Header({
          managed: false
        });
        $('.wrapper').prepend(header.$el);
        Backbone.history.start({
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
    };
  });

}).call(this);
