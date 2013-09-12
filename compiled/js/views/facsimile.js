(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Facsimile, _ref;
    return Facsimile = (function(_super) {
      __extends(Facsimile, _super);

      function Facsimile() {
        _ref = Facsimile.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Facsimile.prototype.initialize = function() {
        this.size = this.options.size || 'large';
        return this.render();
      };

      Facsimile.prototype.render = function() {
        this.$el.html("<img src='" + (this.model.facsimileURL({
          size: this.size
        })) + "' alt='Facsimile view' class='" + this.size + "'>");
        return this.$('img').css({
          width: '100%'
        });
      };

      return Facsimile;

    })(Backbone.View);
  });

}).call(this);
