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
      Entry: require('views/entry'),
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
        "entry/:id/parallel": 'entryParallelView',
        "entry/:id/:version": 'entryVersionView',
        "entry/:id": 'entry'
      };

      MainRouter.prototype.home = function() {
        viewManager.main = $('#main');
        return viewManager.show(Views.Search);
      };

      MainRouter.prototype.entryParallelView = function(id) {
        return viewManager.show(Views.ParallelView, {
          id: id,
          mode: 'parallel'
        });
      };

      MainRouter.prototype.entryVersionView = function(id, version) {
        console.log("Showing version " + version + " for " + id);
        return viewManager.show(Views.Entry, {
          id: id,
          version: version
        });
      };

      MainRouter.prototype.entry = function(id) {
        console.log("Entry " + id);
        return viewManager.show(Views.Entry, {
          id: id
        });
      };

      return MainRouter;

    })(Backbone.Router);
  });

}).call(this);
