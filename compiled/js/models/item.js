(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, Item, _ref;
    BaseModel = require('models/base');
    return Item = (function(_super) {
      __extends(Item, _super);

      function Item() {
        _ref = Item.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Item.prototype.url = function() {
        return "/data/" + this.id + ".json";
      };

      Item.prototype.text = function(key) {
        var texts;
        texts = this.get('paralleltexts');
        if (texts && key in texts) {
          return texts[key].text;
        } else {
          return void 0;
        }
      };

      Item.prototype.annotations = function(key) {
        var texts;
        texts = this.get('paralleltexts');
        if (texts && key in texts) {
          return texts[key].annotations;
        } else {
          return void 0;
        }
      };

      return Item;

    })(BaseModel);
  });

}).call(this);
