(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, ConfigData, config, _ref;
    BaseModel = require('models/base');
    config = require('config');
    ConfigData = (function(_super) {
      __extends(ConfigData, _super);

      function ConfigData() {
        _ref = ConfigData.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ConfigData.prototype.url = function() {
        return config.configDataURL;
      };

      ConfigData.prototype.findPrev = function(id) {
        var ids, pos, _ref1;
        ids = this.get('entryIds');
        pos = ids.indexOf("" + id + ".json");
        return (_ref1 = ids[pos - 1]) != null ? _ref1.replace('.json', '') : void 0;
      };

      ConfigData.prototype.findNext = function(id) {
        var ids, pos, _ref1;
        ids = this.get('entryIds');
        pos = ids.indexOf("" + id + ".json");
        return (_ref1 = ids[pos + 1]) != null ? _ref1.replace('.json', '') : void 0;
      };

      return ConfigData;

    })(BaseModel);
    return new ConfigData;
  });

}).call(this);
