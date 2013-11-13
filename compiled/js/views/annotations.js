(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var AnnotationsView, Backbone, Helpers, annTemplate, config, configData, shorten, _ref;
    Backbone = require('backbone');
    configData = require('models/configdata');
    config = require('config');
    annTemplate = require('text!html/annotations-index.html');
    Helpers = require('helpers/string');
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

      AnnotationsView.prototype.template = _.template(annTemplate);

      AnnotationsView.prototype.className = 'annotations-index';

      AnnotationsView.prototype.initialize = function() {
        var jqxhr,
          _this = this;
        jqxhr = $.getJSON(config.annotationsIndex).done(function(annotations) {
          _this.annotations = annotations;
          return _this.render();
        });
        return jqxhr.fail(function() {
          return console.log(config.annotationsIndex, arguments);
        });
      };

      AnnotationsView.prototype.render = function() {
        return this.$el.html(this.template({
          annotations: this.annotations,
          slugify: Helpers.slugify,
          shorten: shorten,
          config: config
        }));
      };

      return AnnotationsView;

    })(Backbone.View);
  });

}).call(this);
