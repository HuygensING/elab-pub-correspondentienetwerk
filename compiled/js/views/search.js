(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

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

      Home.prototype.hideLoader = function() {
        this.displayLoader = false;
        this.$('.position').fadeIn('fast');
        return this.$('.loader').fadeOut('fast');
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
        var field, name, option, select, _ref1;
        if (this.sortableFields) {
          select = $('<select>');
          _ref1 = this.sortableFields;
          for (field in _ref1) {
            name = _ref1[field];
            option = $('<option>').attr({
              value: field
            }).text(name);
            if (this.sortField && this.sortField === field) {
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
        this.$('.cursor').toggle(this.search.hasNext() || this.search.hasPrev());
        this.$('.cursor .next').toggle(this.search.hasNext());
        return this.$('.cursor .previous').toggle(this.search.hasPrev());
      };

      Home.prototype.renderResults = function() {
        var start, _base, _base1;
        this.$('.results .list').html(this.resultsTemplate({
          results: this.results,
          config: config
        }));
        start = this.results.start + 1;
        this.$('.results .list ol').attr({
          start: start
        });
        this.renderResultsCount();
        this.$('.results .list').hide().fadeIn(125);
        this.$('.position .current').text(typeof (_base = this.search).currentPosition === "function" ? _base.currentPosition() : void 0);
        this.$('.position .total').text(typeof (_base1 = this.search).numPages === "function" ? _base1.numPages() : void 0);
        this.hideLoader();
        this.renderSortableFields();
        return this.renderCursor();
      };

      Home.prototype.render = function() {
        var firstSearch,
          _this = this;
        document.title = configData.get('title');
        this.$el.html(this.template({
          w: configData.get('entryIds')
        }));
        firstSearch = true;
        this.search = new FacetedSearch({
          searchPath: config.searchPath,
          queryOptions: {
            resultRows: config.resultRows,
            term: '*'
          }
        });
        this.search.subscribe('faceted-search:reset', function() {
          return firstSearch = true;
        });
        this.search.subscribe('faceted-search:results', function(response) {
          var f, totalEntries, _i, _len, _ref1, _ref2, _ref3;
          _this.results = response;
          totalEntries = configData.get('entryIds').length;
          _this.results.allIds = totalEntries === ((_ref1 = _this.search.model.get('allIds')) != null ? _ref1.length : void 0) ? [] : _this.search.model.get('allIds');
          firstSearch = false;
          configData.set({
            allResultIds: _this.results.allIds
          });
          if (_this.results.sortableFields != null) {
            _this.sortableFields = {};
            _ref2 = _this.results.facets;
            for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
              f = _ref2[_i];
              if (_ref3 = f.name, __indexOf.call(_this.results.sortableFields, _ref3) >= 0) {
                _this.sortableFields[f.name] = f.title;
              }
            }
          }
          return _this.renderResults();
        });
        this.$('.faceted-search').html(this.search.$el);
        this.$('.faceted-search');
        return this;
      };

      return Home;

    })(Backbone.View);
  });

}).call(this);
