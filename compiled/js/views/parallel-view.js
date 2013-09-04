(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Home, Item, PanelView, Templates, _ref;
    BaseView = require('views/base');
    PanelView = require('views/panel');
    Item = require('models/item');
    Templates = {
      ParallelView: require('text!html/parallel-view.html')
    };
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.className = 'parallel-view';

      Home.prototype.events = {
        'click .add': 'addPanel'
      };

      Home.prototype.initialize = function() {
        var _this = this;
        Home.__super__.initialize.apply(this, arguments);
        this.panels = [];
        if ('id' in this.options) {
          this.model = new Item({
            id: this.options.id
          });
          this.model.fetch({
            success: function() {
              return _this.render();
            }
          });
        }
        return this.render();
      };

      Home.prototype.addPanel = function(e) {
        var panel;
        panel = new PanelView({
          id: this.options.id
        });
        this.$('.panel-container').append(panel.el);
        this.panels.push(panel);
        panel.render();
        return this;
      };

      Home.prototype.render = function() {
        var tmpl, _ref1;
        tmpl = _.template(Templates.ParallelView);
        this.$el.html(tmpl({
          item: (_ref1 = this.model) != null ? _ref1.attributes : void 0
        }));
        this.addPanel().addPanel().addPanel();
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
