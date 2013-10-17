(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, Home, SearchView, configData, _ref;
    Backbone = require('backbone');
    configData = require('models/configdata');
    SearchView = require('views/search');
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.template = require('text!html/home.html');

      Home.prototype.initialize = function() {
        this.searchView = new SearchView;
        return this.render();
      };

      Home.prototype.render = function() {
        console.log("Hioem render");
        this.template = _.template(this.template);
        this.$el.html(this.template());
        this.$('h1').text(configData.get('title'));
        this.$el.append(this.searchView.$el);
        return this;
      };

      return Home;

    })(Backbone.View);
  });

}).call(this);
