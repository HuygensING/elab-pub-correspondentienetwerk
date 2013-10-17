(function() {
  define(function(require) {
    var Backbone, MainRouter, Views, bootstrapTemplate, config, configData, configURL;
    Backbone = require('backbone');
    MainRouter = require('routers/main');
    configData = require('models/configdata');
    config = require('config');
    Views = {
      Main: require('views/home')
    };
    bootstrapTemplate = _.template(require('text!html/body.html'));
    configURL = "" + (window.BASE_URL === '/' ? '' : window.BASE_URL) + "/data/config.json";
    console.log("Loading " + configURL);
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
          },
          error: function() {
            return console.log("Could not fetch config data");
          }
        });
      }
    };
  });

}).call(this);
