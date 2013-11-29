(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var AnnotationsView, Backbone, config, shorten, us, _ref;
    Backbone = require('backbone');
    config = require('config');
    us = require('underscore.string');
    shorten = function(txt, max) {
      var firstWords, lastWords, words;
      if (max == null) {
        max = 50;
      }
      if (!(txt.length > max)) {
        return txt;
      }
      words = txt.split(/\s+/);
      firstWords = words.slice(0, 3).join(' ');
      return lastWords = words.reverse().slice(0, 3).reverse().join(' ');
    };
    return AnnotationsView = (function(_super) {
      __extends(AnnotationsView, _super);

      function AnnotationsView() {
        _ref = AnnotationsView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      AnnotationsView.prototype.template = _.template(require('text!html/annotations-index.html'));

      AnnotationsView.prototype.typeTemplate = _.template(require('text!html/annotations-section.html'));

      AnnotationsView.prototype.className = 'annotations-index';

      AnnotationsView.prototype.events = {
        'click .print': 'printEntry',
        'click .list li.all a': 'selectAllTypes',
        'click .list li a': 'selectType'
      };

      AnnotationsView.prototype.initialize = function(options) {
        var jqxhr,
          _this = this;
        this.options = options != null ? options : {};
        jqxhr = $.getJSON(config.get('annotationsIndex')).done(function(annotations) {
          _this.annotations = annotations;
          _this.types = _.sortBy(_.keys(_this.annotations), function(t) {
            return t.toLowerCase();
          });
          return _this.render();
        });
        return jqxhr.fail(function() {
          return console.log(config.get('annotationsIndex'), arguments);
        });
      };

      AnnotationsView.prototype.printEntry = function(e) {
        e.preventDefault();
        return window.print();
      };

      AnnotationsView.prototype.selectType = function(e) {
        var type;
        type = $(e.currentTarget).attr('data-type');
        this.renderType(type);
        return e.preventDefault();
      };

      AnnotationsView.prototype.selectAllTypes = function() {
        var html, type, _i, _len, _ref1;
        html = "";
        _ref1 = this.types;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          type = _ref1[_i];
          html += this.typeHTML(type);
        }
        return this.renderContents(html);
      };

      AnnotationsView.prototype.typeHTML = function(type) {
        var html;
        return html = this.typeTemplate({
          type: type,
          annotations: this.annotations[type],
          shorten: shorten,
          slugify: us.slugify,
          config: config
        });
      };

      AnnotationsView.prototype.renderType = function(type) {
        return this.renderContents(this.typeHTML(type));
      };

      AnnotationsView.prototype.renderContents = function(html) {
        var _this = this;
        return this.$('.contents').fadeOut(75, function() {
          return _this.$('.contents').html(html).fadeIn(75);
        });
      };

      AnnotationsView.prototype.render = function() {
        var _this = this;
        this.$el.html(this.template({
          types: _.map(this.types, function(t) {
            return {
              name: t,
              count: _this.annotations[t].length
            };
          }),
          shorten: shorten,
          slugify: us.slugify,
          config: config
        }));
        return this.renderType(_.first(this.types));
      };

      return AnnotationsView;

    })(Backbone.View);
  });

}).call(this);
