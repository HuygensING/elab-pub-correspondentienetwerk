(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, EntryView, Home, SearchView, configData, events, _ref;
    Backbone = require('backbone');
    configData = require('models/configdata');
    SearchView = require('views/search');
    EntryView = require('views/entry');
    events = require('events');
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.template = require('text!html/home.html');

      Home.prototype.initialize = function() {
        var _this = this;
        this.searchView = new SearchView;
        this.entryView = new EntryView;
        events.on('change:view:entry', function() {
          _this.searchView.$el.hide();
          return _this.entryView.$el.show();
        });
        events.on('change:view:search', function() {
          _this.entryView.$el.hide();
          return _this.searchView.$el.show();
        });
        return this.render();
      };

      Home.prototype.render = function() {
        this.$el.append(this.searchView.$el);
        this.$el.append(this.entryView.$el);
        return this;
      };

      return Home;

    })(Backbone.View);
  });

}).call(this);
