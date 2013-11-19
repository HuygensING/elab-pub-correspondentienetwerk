(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Helpers, TextView, config, configData, jqv, _ref;
    configData = require('models/configdata');
    config = require('config');
    BaseView = require('views/base');
    Helpers = require('helpers/general');
    jqv = require('jquery-visible');
    return TextView = (function(_super) {
      __extends(TextView, _super);

      function TextView() {
        _ref = TextView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      TextView.prototype.template = require('text!html/text.html');

      TextView.prototype.annotationsTemplate = require('text!html/annotations.html');

      TextView.prototype.events = {
        'click .annotations li': 'scrollToAnnotation'
      };

      TextView.prototype.initialize = function(options) {
        this.options = options;
        this.template = _.template(this.template);
        this.annotationsTemplate = _.template(this.annotationsTemplate);
        this.currentTextLayer = this.options.layer || config.defaultTextLayer;
        if (document.createRange) {
          this.hl = Helpers.highlighter({
            className: 'highlight',
            tagName: 'div'
          });
        } else {
          this.hl = {
            on: function() {},
            off: function() {}
          };
        }
        return this.render();
      };

      TextView.prototype.setView = function(layer) {
        this.currentTextLayer = layer;
        return this.renderContent();
      };

      TextView.prototype.highlightAnnotation = function(markerID) {
        this.hl.on({
          startNode: this.$(".text span[data-marker=begin][data-id=" + markerID + "]")[0],
          endNode: this.$(".text sup[data-marker=end][data-id=" + markerID + "]")[0]
        });
        return console.log("Highliting", markerID);
      };

      TextView.prototype.scrollToAnnotation = function(e) {
        var annID, annotation, target;
        target = $(e.currentTarget);
        annID = target.attr('data-id');
        annotation = this.$(".text span[data-marker=begin][data-id=" + annID + "]");
        if (annotation.visible()) {
          return console.log("Annotation is visible", annID);
        } else {
          return console.log("Not visible");
        }
      };

      TextView.prototype.renderAnnotations = function() {
        var a, annotations, id, liEnter, liLeave, orderedAnnotations, supEnter, supLeave, _i, _len, _ref1,
          _this = this;
        annotations = {};
        _ref1 = this.model.annotations(this.currentTextLayer) || [];
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
        if (document.createRange) {
          supEnter = function(ev) {
            var el, markerID;
            el = ev.currentTarget;
            markerID = $(el).data('id');
            _this.$(".annotations li[data-id=" + markerID + "]").addClass('highlight');
            return _this.hl.on({
              startNode: _this.$(".text span[data-marker=begin][data-id=" + markerID + "]")[0],
              endNode: ev.currentTarget
            });
          };
          supLeave = function(ev) {
            var markerID;
            markerID = $(ev.currentTarget).data('id');
            _this.$(".annotations li[data-id=" + markerID + "]").removeClass('highlight');
            return _this.hl.off();
          };
          this.$('.text sup[data-marker]').hover(supEnter, supLeave);
          liEnter = function(ev) {
            var el, markerID;
            el = ev.currentTarget;
            markerID = $(el).data('id');
            return _this.hl.on({
              startNode: _this.$(".text span[data-marker=begin][data-id=" + markerID + "]")[0],
              endNode: _this.$(".text sup[data-marker=end][data-id=" + markerID + "]")[0]
            });
          };
          liLeave = function() {
            return _this.hl.off();
          };
          this.$('.annotations li').hover(liEnter, liLeave);
        } else {

        }
        return this;
      };

      TextView.prototype.renderLineNumbering = function() {
        var _this = this;
        return this.$('.line').each(function(n, line) {
          return $(line).prepend($('<div class="number"/>').text(n + 1));
        });
      };

      TextView.prototype.renderContent = function() {
        var text;
        text = this.model.text(this.currentTextLayer);
        if (text != null ? text.length : void 0) {
          this.$('.text').html(text);
          this.renderLineNumbering();
        } else {
          this.$('.text').html("<p class=no-data>" + this.currentTextLayer + " text layer is empty</p>");
        }
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
