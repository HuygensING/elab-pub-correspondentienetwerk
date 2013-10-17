(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Backbone, FacetedSearch, Home, Templates, config, configData, _ref;
    Backbone = require('backbone');
    config = require('config');
    configData = require('models/configdata');
    FacetedSearch = require('../../lib/faceted-search/stage/js/main');
    Templates = {
      Search: require('text!html/search.html'),
      ResultsList: require('text!html/results-list.html')
    };
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.className = 'wrapper';

      Home.prototype.events = {
        'click .results .body li': 'resultClicked',
        'click .results .next': 'nextResults',
        'click .results .previous': 'previousResults',
        'change .sort select': 'sortResults'
      };

      Home.prototype.initialize = function() {
        this.template = _.template(Templates.Search);
        this.resultsTemplate = _.template(Templates.ResultsList);
        console.log("REE");
        return this.render();
      };

      Home.prototype.showLoader = function() {
        var doIt,
          _this = this;
        this.displayLoader = true;
        doIt = function() {
          if (_this.displayLoader) {
            _this.$('.position').hide();
            return _this.$('.loader').fadeIn('fast');
          }
        };
        return _.delay(doIt, 200);
      };

      Home.prototype.nextResults = function() {
        this.showLoader();
        return this.search.next();
      };

      Home.prototype.previousResults = function() {
        this.showLoader();
        return this.search.prev();
      };

      Home.prototype.sortResults = function(e) {
        this.sortField = $(e.currentTarget).val();
        return this.search.sortResultsBy(this.sortField);
      };

      Home.prototype.renderSortableFields = function() {
        var f, option, select, _i, _len, _ref1, _ref2;
        if (this.sortableFields) {
          select = $('<select>');
          _ref1 = this.sortableFields;
          for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
            f = _ref1[_i];
            option = $('<option>').attr({
              value: f
            }).text(((_ref2 = config.sortableFieldNames) != null ? _ref2[f] : void 0) || f);
            if (this.sortField && this.sortField === f) {
              option.attr('selected', 'selected');
            }
            select.append(option);
          }
          this.$('.controls .sort').empty().append('<span>Order by&nbsp;</span>');
          this.$('.controls .sort').append(select);
        }
        return this;
      };

      Home.prototype.renderResultsCount = function() {
        return this.$('.results h3 .number-of-results').text(this.results.numFound);
      };

      Home.prototype.renderCursor = function() {
        console.log("Has next/prev", this.search.hasNext(), this.search.hasPrev());
        this.$('.cursor').toggle(this.search.hasNext() || this.search.hasPrev());
        this.$('.cursor .next').toggle(this.search.hasNext());
        return this.$('.cursor .previous').toggle(this.search.hasPrev());
      };

      Home.prototype.renderResults = function() {
        var _base, _base1;
        this.$('.results .list').html(this.resultsTemplate({
          results: this.results,
          config: config
        }));
        this.renderResultsCount();
        this.$('.position .current').text(typeof (_base = this.search).currentPosition === "function" ? _base.currentPosition() : void 0);
        this.$('.position .total').text(typeof (_base1 = this.search).numPages === "function" ? _base1.numPages() : void 0);
        this.$('.position').show();
        this.$('.loader').hide();
        this.renderSortableFields();
        return this.renderCursor();
      };

      Home.prototype.render = function() {
        var _this = this;
        $('title').text(configData.get('title'));
        this.$el.html(this.template({
          w: configData.get('entryIds')
        }));
        this.search = new FacetedSearch({
          searchPath: config.searchPath,
          queryOptions: {
            resultRows: config.resultRows,
            term: '*'
          }
        });
        this.search.subscribe('results:change', function(response) {
          _this.results = response;
          if ('sortableFields' in response) {
            _this.sortableFields = response.sortableFields;
          }
          return _this.renderResults();
        });
        this.$('.faceted-search').html(this.search.$el);
        return this;
      };

      return Home;

    })(Backbone.View);
  });

}).call(this);
