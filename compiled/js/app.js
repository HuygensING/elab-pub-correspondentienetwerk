(function() {
  define(function(require) {
    var Backbone, MainController, MainRouter, bootstrapTemplate, config, configData, configURL, rootURL;
    Backbone = require('backbone');
    MainRouter = require('routers/main');
    configData = require('models/configdata');
    config = require('config');
    MainController = require('views/home');
    bootstrapTemplate = _.template(require('text!html/body.html'));
    rootURL = window.BASE_URL.replace(/https?:\/\/[^\/]+/, '');
    configURL = "" + (window.BASE_URL === '/' ? '' : window.BASE_URL) + "/data/config.json";
    return {
      initialize: function() {
        var _this = this;
        return configData.fetch({
          url: configURL,
          success: function() {
            var mainController, mainRouter;
            $('body').html(bootstrapTemplate());
            $('.page-header h1 a').text(configData.get('title'));
            mainController = new MainController({
              el: '#main'
            });
            mainRouter = new MainRouter({
              controller: mainController,
              root: rootURL
            });
            mainRouter.start();
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
            $('body').html('An unknown error occurred while attempting to load the application.');
            return console.error("Could not fetch config data", typeof JSON !== "undefined" && JSON !== null ? JSON.stringify(o) : void 0);
          }
        });
      }
    };
  });

}).call(this);
