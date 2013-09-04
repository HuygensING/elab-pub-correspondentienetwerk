(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var PanelTextView, Templates, _ref;
    Templates = {
      PanelTextView: require('text!html/panel-text.html')
    };
    return PanelTextView = (function(_super) {
      __extends(PanelTextView, _super);

      function PanelTextView() {
        _ref = PanelTextView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PanelTextView.prototype.initialize = function() {
        if (this.model) {
          return this.render();
        }
      };

      PanelTextView.prototype.render = function() {
        var template;
        template = _.template(Templates.PanelTextView);
        return this.$el.html(template({
          item: this.model.attributes,
          version: this.options.version || "Translation"
        }));
      };

      return PanelTextView;

    })(Backbone.View);
  });

}).call(this);
