(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, Facsimile, _ref;
    Backbone = require('backbone');
    return Facsimile = (function(_super) {
      __extends(Facsimile, _super);

      function Facsimile() {
        _ref = Facsimile.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Facsimile.prototype.template = require('text!html/facsimile-zoom.html');

      Facsimile.prototype.initialize = function(options) {
        this.options = options;
        this.template = _.template(this.template);
        this.size = this.options.size || 'large';
        this.page = this.options.page || 0;
        return this.render();
      };

      Facsimile.prototype.render = function() {
        return this.$el.html(this.template({
          model: this.model,
          entry: this.model.attributes,
          page: this.page,
          size: this.size
        }));
      };

      return Facsimile;

    })(Backbone.View);
  });

}).call(this);
