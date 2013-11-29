(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, Config, basePath, us, _ref;
    Backbone = require('backbone');
    us = require('underscore.string');
    basePath = BASE_URL;
    if (basePath === '/') {
      basePath = '';
    }
    Config = (function(_super) {
      __extends(Config, _super);

      function Config() {
        _ref = Config.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Config.prototype.defaults = {
        textLayer: 'Diplomatic',
        basePath: basePath,
        annotationsIndex: "" + basePath + "/data/annotation_index.json",
        configDataURL: "" + basePath + "/data/config.json",
        itemLabel: 'entry',
        itemLabelPlural: 'entries',
        defaultTextLayer: 'Diplomatic',
        resultRows: 25,
        panelSize: 'large',
        searchPath: "http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search"
      };

      Config.prototype.parse = function(data) {
        var e, id, _i, _len, _ref1;
        data.entryIds = [];
        data.entryNames = {};
        _ref1 = data.entries;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          e = _ref1[_i];
          id = e['datafile'];
          data.entryIds.push(id);
          data.entryNames[id] = e['name'];
        }
        return data;
      };

      Config.prototype.entryName = function(id) {
        return this.get('entryNames')[id];
      };

      Config.prototype.findPrev = function(id) {
        var ids, pos, _ref1;
        ids = this.get('entryIds');
        pos = _.indexOf(ids, "" + id + ".json");
        return (_ref1 = ids[pos - 1]) != null ? _ref1.replace('.json', '') : void 0;
      };

      Config.prototype.findNext = function(id) {
        var ids, pos, _ref1;
        ids = this.get('entryIds');
        pos = _.indexOf(ids, "" + id + ".json");
        return (_ref1 = ids[pos + 1]) != null ? _ref1.replace('.json', '') : void 0;
      };

      Config.prototype.nextURL = function(id) {
        var next;
        next = this.findNext(id);
        if (next) {
          return this.entryURL(next);
        }
      };

      Config.prototype.prevURL = function(id) {
        var prev;
        prev = this.findPrev(id);
        if (prev) {
          return this.entryURL(prev);
        }
      };

      Config.prototype.entryURL = function(id, textLayer, annotation) {
        var base;
        base = "/entry/" + id;
        if ((annotation != null) && (textLayer != null)) {
          return "" + base + "/" + (us.slugify(textLayer)) + "/" + annotation;
        } else if (textLayer != null) {
          return "" + base + "/" + (us.slugify(textLayer));
        } else {
          return base;
        }
      };

      Config.prototype.entryDataURL = function(id) {
        return "" + (this.get('basePath')) + "/data/" + id + ".json";
      };

      Config.prototype.entryParallelURL = function(id) {
        return "/entry/" + id + "/parallel";
      };

      Config.prototype.slugToLayer = function(slug) {
        var layer, _i, _len, _ref1;
        _ref1 = this.get('textLayers') || [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          layer = _ref1[_i];
          if (slug === us.slugify(layer)) {
            return layer;
          }
        }
      };

      return Config;

    })(Backbone.Model);
    return new Config;
  });

}).call(this);
