(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var AnnotationsView, Backbone, Entry, EntryCollection, EntryView, Home, SearchView, config, events, _ref;
    Backbone = require('backbone');
    config = require('config');
    SearchView = require('views/search');
    EntryView = require('views/entry');
    AnnotationsView = require('views/annotations');
    events = require('events');
    EntryCollection = require('collections/entries');
    Entry = require('models/entry');
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.template = require('text!html/home.html');

      Home.prototype.initialize = function() {
        this.entries = new EntryCollection;
        this.searchView = new SearchView;
        this.entryView = {};
        this.annotationsView = new AnnotationsView;
        this.currentView = this.searchView;
        return this.render();
      };

      Home.prototype.showEntryLayer = function(id, layer) {
        return this.showEntry({
          id: id,
          layer: layer
        });
      };

      Home.prototype.showEntryHighlightAnnotation = function(id, layer, annotation) {
        return this.showEntry({
          id: id,
          layerSlug: layer,
          annotation: annotation
        });
      };

      Home.prototype.showEntry = function(options) {
        var attachEntryView,
          _this = this;
        if (!_.isObject(options)) {
          options = {
            id: options
          };
        }
        attachEntryView = function() {
          _.extend(options, {
            model: _this.entries.get(options.id)
          });
          _this.entryView = new EntryView(options);
          _this.$('.entry-view').html(_this.entryView.el);
          return _this.switchView(_this.entryView);
        };
        if (this.entries.get(options.id)) {
          return attachEntryView();
        } else {
          return this.entries.add({
            id: options.id
          }).fetch().done(function() {
            return attachEntryView();
          });
        }
      };

      Home.prototype.showSearch = function() {
        return this.switchView(this.searchView);
      };

      Home.prototype.showAnnotationsIndex = function() {
        return this.switchView(this.annotationsView);
      };

      Home.prototype.switchView = function(newView) {
        if (newView !== this.currentView) {
          this.currentView.$el.fadeOut(75, function() {
            return newView.$el.fadeIn(150);
          });
        }
        return this.currentView = newView;
      };

      Home.prototype.render = function() {
        var _ref1;
        this.template = _.template(this.template);
        this.$el.html(this.template());
        this.$('.search-view').html(this.searchView.$el);
        this.$('.entry-view').html((_ref1 = this.entryView) != null ? _ref1.$el : void 0);
        this.$('.annotations-view').html(this.annotationsView.$el);
        return this;
      };

      return Home;

    })(Backbone.View);
  });

}).call(this);
