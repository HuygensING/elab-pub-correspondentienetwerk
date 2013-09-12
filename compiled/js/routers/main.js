(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, MainRouter, Pubsub, Views, configData, currentUser, viewManager, _ref,
      _this = this;
    Backbone = require('backbone');
    viewManager = require('managers/view');
    Pubsub = require('managers/pubsub');
    currentUser = require('models/currentUser');
    configData = require('models/configdata');
    configData.on('change', function() {
      return $('title').text(configData.get('title'));
    });
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
        'item/:id': 'item',
        'item/:id/parallel': 'itemParallelView',
        'item/:id/:version': 'itemVersionView'
      };

      MainRouter.prototype.home = function() {
        return viewManager.show(Views.Search);
      };

      MainRouter.prototype.itemParallelView = function(id) {
        return viewManager.show(Views.ParallelView, {
          id: id,
          mode: 'parallel'
        });
      };

      MainRouter.prototype.itemVersionView = function(id, version) {
        return viewManager.show(Views.Item, {
          id: id,
          version: version
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
