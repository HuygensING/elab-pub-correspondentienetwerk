(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, MainRouter, Pubsub, Views, currentUser, viewManager, _ref;
    Backbone = require('backbone');
    viewManager = require('managers/view');
    Pubsub = require('managers/pubsub');
    currentUser = require('models/currentUser');
    Views = {
      Home: require('views/home'),
      Search: require('views/search'),
      Item: require('views/item'),
      ParallelView: require('views/parallel-view')
    };
    return MainRouter = (function(_super) {
      __extends(MainRouter, _super);

      function MainRouter() {
        _ref = MainRouter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      MainRouter.prototype.initialize = function() {
        _.extend(this, Pubsub);
        return this.on('route', this.show, this);
      };

      MainRouter.prototype['routes'] = {
        '': 'home',
        'parallel/:id': 'parallelView',
        'item/:id': 'item'
      };

      MainRouter.prototype.home = function() {
        return viewManager.show(Views.Search);
      };

      MainRouter.prototype.parallelView = function(id) {
        return viewManager.show(Views.ParallelView, {
          id: id
        });
      };

      MainRouter.prototype.item = function(id) {
        return viewManager.show(Views.Item, {
          id: id
        });
      };

      return MainRouter;

    })(Backbone.Router);
  });

}).call(this);
