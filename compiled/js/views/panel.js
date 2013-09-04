(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Item, PanelTextView, PanelView, Templates, jqu, _ref;
    Item = require('models/item');
    PanelTextView = require('views/panel-text-view');
    Templates = {
      Panel: require('text!html/panel.html')
    };
    jqu = require('jquery-ui/jquery-ui');
    console.log(jqu);
    return PanelView = (function(_super) {
      __extends(PanelView, _super);

      function PanelView() {
        _ref = PanelView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PanelView.prototype.className = 'panel';

      PanelView.prototype.events = {
        'click .selection li': 'selectText'
      };

      PanelView.prototype.initialize = function() {
        var _this = this;
        if ('id' in this.options && !this.model) {
          this.model = new Item({
            id: this.options.id
          });
          return this.model.fetch({
            success: function() {
              return _this.render();
            }
          });
        } else if (this.model) {
          return this.render();
        }
      };

      PanelView.prototype.selectText = function(e) {
        var target, textVersion;
        target = $(e.currentTarget);
        textVersion = target.data('toggle');
        this.subView = new PanelTextView({
          model: this.model,
          version: textVersion
        });
        return this.$('.view').html(this.subView.el);
      };

      PanelView.prototype.positionSelectionTab = function() {
        var ml, mt;
        ml = this.$('.selection').outerWidth() / 2;
        mt = this.$('.selection').outerHeight();
        return this.$('.selection').css({
          left: '50%',
          'margin-left': "-" + ml + "px",
          'margin-top': "-" + mt + "px"
        });
      };

      PanelView.prototype.render = function() {
        var tmpl, _ref1;
        tmpl = _.template(Templates.Panel);
        this.$el.html(tmpl({
          item: (_ref1 = this.model) != null ? _ref1.attributes : void 0
        }));
        this.positionSelectionTab();
        return this;
      };

      return PanelView;

    })(Backbone.View);
  });

}).call(this);
