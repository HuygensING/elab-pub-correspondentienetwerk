(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, ConfigData, _ref;
    BaseModel = require('models/base');
    ConfigData = (function(_super) {
      __extends(ConfigData, _super);

      function ConfigData() {
        _ref = ConfigData.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ConfigData.prototype.url = function() {
        return "/data/config.json";
      };

      ConfigData.prototype.findPrev = function(id) {
        var ids, pos;
        ids = this.get('entryIds');
        pos = ids.indexOf("" + id + ".json");
        return ids[pos - 1];
      };

      ConfigData.prototype.findNext = function(id) {
        var ids, pos;
        ids = this.get('entryIds');
        pos = ids.indexOf("" + id + ".json");
        return ids[pos + 1];
      };

      return ConfigData;

    })(BaseModel);
    return new ConfigData;
  });

}).call(this);
