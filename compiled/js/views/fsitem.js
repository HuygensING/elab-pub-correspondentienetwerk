(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Home, Templates, _ref;
    BaseView = require('views/base');
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
        Home.__super__.initialize.apply(this, arguments);
        return this.render();
      };

      Home.prototype.render = function() {
        var rtpl;
        rtpl = _.template(Templates.Home);
        this.$el.html(rtpl);
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
