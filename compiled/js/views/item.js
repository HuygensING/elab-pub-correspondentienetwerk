(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Home, Item, Templates, _ref;
    BaseView = require('views/base');
    Item = require('models/item');
    Templates = {
      Home: require('text!html/item.html')
    };
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.initialize = function() {
        var _this = this;
        Home.__super__.initialize.apply(this, arguments);
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

      Home.prototype.render = function() {
        var rtpl;
        rtpl = _.template(Templates.Home);
        if (this.model.has('name')) {
          console.log(this.model.attributes);
          this.$el.html(rtpl({
            item: this.model.attributes
          }));
        } else {
          this.$el.html(rtpl({
            item: {}
          }));
        }
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
