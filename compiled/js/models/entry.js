(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, Entry, config, _ref;
    BaseModel = require('models/base');
    config = require('config');
    return Entry = (function(_super) {
      __extends(Entry, _super);

      function Entry() {
        _ref = Entry.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Entry.prototype.url = function() {
        return config.entryDataURL(this.id);
      };

      Entry.prototype.parse = function(data) {
        var i, page, text, version, _i, _len, _ref1;
        if (data.paralleltexts != null) {
          for (version in data.paralleltexts) {
            i = 1;
            text = data.paralleltexts[version].text;
            text = '<div class="line">' + text.replace(/\n|<br>/g, '</div><div class="line">') + '</div>';
            text = text.replace(/(<div class="line">)(\s*<span[^>]+><\/span>\s*)?\s*(<\/div>)/mg, "$1$2&nbsp;$3");
            text = text.replace(/^<div class="line">&nbsp;<\/div>$/mg, '');
            data.paralleltexts[version].text = text;
          }
        }
        _ref1 = data.facsimiles;
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          page = _ref1[_i];
          page.zoom = page.zoom.replace('adore-huygens-viewer-2.0', 'adore-huygens-viewer-2.1');
        }
        return data;
      };

      Entry.prototype.text = function(key) {
        var texts;
        texts = this.get('paralleltexts');
        if (texts && key in texts) {
          return texts[key].text;
        } else {
          return void 0;
        }
      };

      Entry.prototype.textLayers = function() {
        return _.keys(this.get('paralleltexts'));
      };

      Entry.prototype.annotations = function(key) {
        var texts;
        texts = this.get('paralleltexts');
        if (texts && key in texts) {
          return texts[key].annotations;
        } else {
          return void 0;
        }
      };

      Entry.prototype.facsimileZoomURL = function(page) {
        var _ref1, _ref2;
        return (_ref1 = this.get('facsimiles')) != null ? (_ref2 = _ref1[page]) != null ? _ref2.zoom : void 0 : void 0;
      };

      Entry.prototype.facsimileURL = function(options) {
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

      return Entry;

    })(BaseModel);
  });

}).call(this);
