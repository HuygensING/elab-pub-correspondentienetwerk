(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, Item, config, _ref;
    BaseModel = require('models/base');
    config = require('config');
    return Item = (function(_super) {
      __extends(Item, _super);

      function Item() {
        _ref = Item.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Item.prototype.url = function() {
        return "" + config.basePath + "/data/" + this.id + ".json";
      };

      Item.prototype.parse = function(data) {
        var i, version,
          _this = this;
        if (data.paralleltexts != null) {
          for (version in data.paralleltexts) {
            i = 1;
            data.paralleltexts[version].text = data.paralleltexts[version].text.replace(/<ab id="(.*?)"\/>/g, function(match, p1, offset, string) {
              return '<span data-marker="begin" data-id="' + p1 + '"></span>';
            });
            data.paralleltexts[version].text = data.paralleltexts[version].text.replace(/<ae id="(.*?)"\/>/g, function(match, p1, offset, string) {
              return '<sup data-marker="end" data-id="' + p1 + '">' + (i++) + '</sup> ';
            });
          }
        }
        return data;
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

      Item.prototype.textVersions = function() {
        var key, _results;
        _results = [];
        for (key in this.get('paralleltexts')) {
          _results.push(key);
        }
        return _results;
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

      Item.prototype.facsimileURL = function(options) {
        var facsimiles, level, size, sizes, url;
        sizes = {
          small: 2,
          medium: 3,
          large: 4
        };
        size = (options != null ? options.size : void 0) || 'medium';
        level = sizes[size];
        facsimiles = this.get('facsimiles');
        url = facsimiles[0].thumbnail;
        return url.replace(/svc.level=\d+/, "svc.level=" + level);
      };

      return Item;

    })(BaseModel);
  });

}).call(this);
