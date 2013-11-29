(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, MainRouter, config, events, viewManager, _ref,
      _this = this;
    Backbone = require('backbone');
    viewManager = require('managers/view');
    events = require('events');
    config = require('config');
    config.on('change', function() {
      return document.title = config.get('title');
    });
    return MainRouter = (function(_super) {
      __extends(MainRouter, _super);

      function MainRouter() {
        _ref = MainRouter.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      MainRouter.prototype.routes = {
        '': 'showSearch',
        'annotations/': 'showAnnotationsIndex',
        'entry/:id/parallel': 'showEntryParallelView',
        'entry/:id/:layer/:annotation': 'showEntryHighlightAnnotation',
        'entry/:id/:layer': 'showEntryLayer',
        'entry/:id': 'showEntry'
      };

      MainRouter.prototype.initialize = function(options) {
        MainRouter.__super__.initialize.apply(this, arguments);
        this.controller = options.controller, this.root = options.root;
        return this.processRoutes();
      };

      MainRouter.prototype.start = function() {
        return Backbone.history.start({
          root: this.root,
          pushState: true
        });
      };

      MainRouter.prototype.processRoutes = function() {
        var method, methodName, route, _ref1, _results;
        _ref1 = this.routes;
        _results = [];
        for (route in _ref1) {
          methodName = _ref1[route];
          if (!(methodName in this.controller)) {
            continue;
          }
          method = _.bind(this.controller[methodName], this.controller);
          _results.push(this.route(route, methodName, method));
        }
        return _results;
      };

      return MainRouter;

    })(Backbone.Router);
  });

}).call(this);
