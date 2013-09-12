(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Home, configData, _ref;
    BaseView = require('views/base');
    configData = require('models/configdata');
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.template = require('text!html/home.html');

      Home.prototype.initialize = function() {
        Home.__super__.initialize.apply(this, arguments);
        return this.render();
      };

      Home.prototype.render = function() {
        this.template = _.template(this.template);
        this.$el.html(this.template());
        this.$('h1').text(configData.get('title'));
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
