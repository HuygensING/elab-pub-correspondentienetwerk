(function() {
  define(function(require) {
    var Backbone, MainRouter, Views, bootstrapTemplate, config, configData, configURL, rootURL;
    Backbone = require('backbone');
    MainRouter = require('routers/main');
    configData = require('models/configdata');
    config = require('config');
    Views = {
      Main: require('views/home')
    };
    bootstrapTemplate = _.template(require('text!html/body.html'));
    rootURL = window.BASE_URL.replace(/https?:\/\/[^\/]+/, '');
    configURL = "" + (window.BASE_URL === '/' ? '' : window.BASE_URL) + "/data/config.json";
    return {
      initialize: function() {
        var _this = this;
        return configData.fetch({
          url: configURL,
          success: function() {
            var mainRouter, mainView;
            $('body').html(bootstrapTemplate());
            $('header h1').text(configData.get('title'));
            mainRouter = new MainRouter;
            mainView = new Views.Main({
              el: '#main'
            });
            Backbone.history.start({
              root: rootURL,
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
          },
          error: function(m, o) {
            return console.log("Could not fetch config data", JSON.stringify(o));
          }
        });
      }
    };
  });

}).call(this);
