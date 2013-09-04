(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, FacetedSearch, Home, Templates, config, entriesList, _ref;
    config = require('config');
    entriesList = JSON.parse(require('text!../../../data/config.json'));
    BaseView = require('views/base');
    FacetedSearch = require('../../lib/faceted-search/stage/js/main');
    Templates = {
      Search: require('text!html/search.html')
    };
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.events = {
        'click .results li': 'cl'
      };

      Home.prototype.initialize = function() {
        Home.__super__.initialize.apply(this, arguments);
        return this.render();
      };

      Home.prototype.cl = function(e) {
        return console.log("Clicked ", $(e.currentTarget).text());
      };

      Home.prototype.render = function() {
        var fs, rtpl;
        rtpl = _.template(Templates.Search);
        this.$el.html(rtpl({
          w: entriesList
        }));
        fs = new FacetedSearch({
          searchUrl: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search',
          queryOptions: {
            resultRows: config.resultRows,
            term: '*'
          }
        });
        this.$('.faceted-search').html(fs.$el);
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
