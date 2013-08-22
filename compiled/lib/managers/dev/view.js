(function() {
  define(function(require) {
    var Backbone, Collections, ViewManager;
    Backbone = require('backbone');
    Collections = {
      'View': require('collections/view')
    };
    ViewManager = (function() {
      var currentViews, selfDestruct;

      currentViews = new Collections.View();

      ViewManager.prototype.debugCurrentViews = currentViews;

      selfDestruct = function(view) {
        if (!currentViews.has(view)) {
          console.error('Unknown view!');
          return false;
        }
        if (view.destroy) {
          return view.destroy();
        } else {
          return view.remove();
        }
      };

      function ViewManager() {
        this.main = $('div#main');
      }

      ViewManager.prototype.clear = function(view) {
        if (view) {
          selfDestruct(view);
          return currentViews.remove(view.cid);
        } else {
          currentViews.each(function(model) {
            return selfDestruct(model.get('view'));
          });
          return currentViews.reset();
        }
      };

      ViewManager.prototype.register = function(view) {
        if (view) {
          return currentViews.add({
            'id': view.cid,
            'view': view
          });
        }
      };

      ViewManager.prototype.show = function(View, query) {
        var html, view;
        this.clear();
        query = query || {};
        view = new View(query);
        html = view == null ? '' : view.$el;
        return this.main.html(html);
      };

      return ViewManager;

    })();
    return new ViewManager();
  });

}).call(this);
