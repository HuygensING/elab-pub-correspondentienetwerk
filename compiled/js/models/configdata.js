(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, ConfigData, config, us, _ref;
    BaseModel = require('models/base');
    config = require('config');
    us = require('underscore.string');
    ConfigData = (function(_super) {
      __extends(ConfigData, _super);

      function ConfigData() {
        _ref = ConfigData.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ConfigData.prototype.defaults = {
        textLayer: 'Diplomatic'
      };

      ConfigData.prototype.parse = function(data) {
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

      ConfigData.prototype.entryName = function(id) {
        return this.get('entryNames')[id];
      };

      ConfigData.prototype.findPrev = function(id) {
        var ids, pos, _ref1;
        ids = this.get('entryIds');
        pos = _.indexOf(ids, "" + id + ".json");
        return (_ref1 = ids[pos - 1]) != null ? _ref1.replace('.json', '') : void 0;
      };

      ConfigData.prototype.findNext = function(id) {
        var ids, pos, _ref1;
        ids = this.get('entryIds');
        pos = _.indexOf(ids, "" + id + ".json");
        return (_ref1 = ids[pos + 1]) != null ? _ref1.replace('.json', '') : void 0;
      };

      ConfigData.prototype.nextURL = function(id) {
        var next;
        next = this.findNext(id);
        if (next) {
          return config.entryURL(next);
        }
      };

      ConfigData.prototype.prevURL = function(id) {
        var prev;
        prev = this.findPrev(id);
        if (prev) {
          return config.entryURL(prev);
        }
      };

      ConfigData.prototype.slugToLayer = function(slug) {
        var layer, _i, _len, _ref1;
        _ref1 = this.get('textLayers') || [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          layer = _ref1[_i];
          if (slug === us.slugify(layer)) {
            return layer;
          }
        }
      };

      return ConfigData;

    })(BaseModel);
    return new ConfigData;
  });

}).call(this);
