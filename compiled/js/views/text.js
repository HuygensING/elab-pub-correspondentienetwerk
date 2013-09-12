(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Helpers, TextView, config, configData, _ref;
    configData = require('models/configdata');
    config = require('config');
    BaseView = require('views/base');
    Helpers = require('helpers/general');
    return TextView = (function(_super) {
      __extends(TextView, _super);

      function TextView() {
        _ref = TextView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TextView.prototype.template = require('text!html/text.html');

      TextView.prototype.annotationsTemplate = require('text!html/annotations.html');

      TextView.prototype.initialize = function() {
        this.template = _.template(this.template);
        this.annotationsTemplate = _.template(this.annotationsTemplate);
        this.currentTextVersion = this.options.version || config.defaultTextVersion;
        this.highlighter = new Helpers.highlighter;
        return this.render();
      };

      TextView.prototype.setView = function(version) {
        this.currentTextVersion = version;
        return this.renderContent();
      };

      TextView.prototype.renderAnnotations = function() {
        var a, annotations, hl, id, liEnter, liLeave, orderedAnnotations, supEnter, supLeave, _i, _len, _ref1,
          _this = this;
        annotations = {};
        _ref1 = this.model.annotations(this.currentTextVersion) || [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          a = _ref1[_i];
          annotations[a.n] = a;
        }
        orderedAnnotations = (function() {
          var _j, _len1, _ref2, _results;
          _ref2 = this.$('.text sup').map(function() {
            return $(this).data('id');
          });
          _results = [];
          for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
            id = _ref2[_j];
            _results.push(annotations[id]);
          }
          return _results;
        }).call(this);
        this.$('.annotations').html(this.annotationsTemplate({
          annotations: orderedAnnotations
        }));
        hl = Helpers.highlighter({
          className: 'highlight',
          tagName: 'div'
        });
        supEnter = function(ev) {
          var el, markerID;
          el = ev.currentTarget;
          markerID = $(el).data('id');
          _this.$(".annotations li[data-id=" + markerID + "]").addClass('highlight');
          return hl.on({
            startNode: _this.$(".text span[data-marker=begin][data-id=" + markerID + "]")[0],
            endNode: ev.currentTarget
          });
        };
        supLeave = function(ev) {
          var markerID;
          markerID = $(ev.currentTarget).data('id');
          _this.$(".annotations li[data-id=" + markerID + "]").removeClass('highlight');
          return hl.off();
        };
        this.$('.text sup[data-marker]').hover(supEnter, supLeave);
        liEnter = function(ev) {
          var el, markerID;
          el = ev.currentTarget;
          markerID = $(el).data('id');
          return hl.on({
            startNode: _this.$(".text span[data-marker=begin][data-id=" + markerID + "]")[0],
            endNode: _this.$(".text sup[data-marker=end][data-id=" + markerID + "]")[0]
          });
        };
        liLeave = function() {
          return hl.off();
        };
        this.$('.annotations li').hover(liEnter, liLeave);
        return this;
      };

      TextView.prototype.renderContent = function() {
        var text;
        text = this.model.text(this.currentTextVersion);
        this.$('.text').html(text);
        this.renderAnnotations();
        return this;
      };

      TextView.prototype.render = function() {
        this.$el.html(this.template());
        return this.renderContent();
      };

      return TextView;

    })(Backbone.View);
  });

}).call(this);
