(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, MainRouter, Views, configData, events, viewManager, _ref,
      _this = this;
    Backbone = require('backbone');
    viewManager = require('managers/view');
    events = require('events');
    configData = require('models/configdata');
    configData.on('change', function() {
      return document.title = configData.get('title');
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
        var _this = this;
        this.on('route', this.show, this);
        return this.on('route', function() {
          return events.trigger('change:view', arguments);
        });
      };

      MainRouter.prototype['routes'] = {
        '': 'home',
        "entry/:id/parallel": 'entryParallelView',
        "entry/:id/:version": 'entryVersionView',
        "entry/:id": 'entry'
      };

      MainRouter.prototype.home = function() {
        return events.trigger('change:view:search');
      };

      MainRouter.prototype.entryParallelView = function(id) {
        return events.trigger('change:view:entry', {
          id: id,
          mode: 'parallel'
        });
      };

      MainRouter.prototype.entryVersionView = function(id, version) {
        return events.trigger('change:view:entry', {
          id: id,
          version: version
        });
      };

      MainRouter.prototype.entry = function(id) {
        return events.trigger('change:view:entry', {
          id: id
        });
      };

      return MainRouter;

    })(Backbone.Router);
  });

}).call(this);
