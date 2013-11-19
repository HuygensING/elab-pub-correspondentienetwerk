(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Entry, Home, ParallelView, TextView, config, configData, events, _ref;
    configData = require('models/configdata');
    config = require('config');
    events = require('events');
    BaseView = require('views/base');
    TextView = require('views/text');
    ParallelView = require('views/parallel-view');
    Entry = require('models/entry');
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.baseTemplate = require('text!html/entry/base.html');

      Home.prototype.headerTemplate = require('text!html/entry/header.html');

      Home.prototype.metadataTemplate = require('text!html/entry/metadata.html');

      Home.prototype.contentsTemplate = require('text!html/entry/contents.html');

      Home.prototype.className = 'entry';

      Home.prototype.events = {
        'click .layers li': 'changeTextLayer',
        'click .more button': 'toggleMoreMetadata',
        'click .parallel button': 'showParallelView',
        'click .thumbnail': 'showThumbnailParallelView',
        'click a.print': 'printEntry'
      };

      Home.prototype.initialize = function(options) {
        var doCheck,
          _this = this;
        this.options = options != null ? options : {};
        Home.__super__.initialize.apply(this, arguments);
        this.baseTemplate = _.template(this.baseTemplate);
        this.headerTemplate = _.template(this.headerTemplate);
        this.metadataTemplate = _.template(this.metadataTemplate);
        this.contentsTemplate = _.template(this.contentsTemplate);
        this.currentTextLayer = this.options.layerSlug != null ? configData.slugToLayer(this.options.layerSlug) : this.options.layer != null ? this.options.layer : configData.get('textLayer');
        this.didScroll = false;
        this.$el.click(function() {
          return this.didScroll = true;
        });
        doCheck = function() {
          var didScroll;
          if (_this.didScroll) {
            didScroll = false;
            return _this.positionTextView();
          }
        };
        $('body, html').scroll(function(e) {
          return _this.didScroll = true;
        });
        return this.render();
      };

      Home.prototype.setActiveTextLayer = function(layer) {
        var li;
        li = this.$(".layers li[data-toggle=" + layer + "]");
        return li.addClass('active').siblings().removeClass('active');
      };

      Home.prototype.changeTextLayer = function(e) {
        this.currentTextLayer = $(e.currentTarget).data('toggle');
        this.setActiveTextLayer(this.currentTextLayer);
        this.textView.setView(this.currentTextLayer);
        return configData.set({
          textLayer: this.currentTextLayer
        });
      };

      Home.prototype.toggleMoreMetadata = function() {
        this.$('.metadata').toggleClass('more');
        this.$('.metadata button').toggleClass('more');
        return configData.set({
          showMetaData: this.$('.metadata').hasClass('more')
        });
      };

      Home.prototype.showParallelView = function() {
        this.pv = new ParallelView({
          model: this.model
        });
        this.$('.parallel-view-container').empty().html(this.pv.el);
        this.pv.show();
        return this.pv;
      };

      Home.prototype.showThumbnailParallelView = function(e) {
        var page, target;
        target = $(e.currentTarget);
        page = target.data('page');
        this.pv = this.showParallelView();
        this.pv.clearPanels();
        this.pv.addPanel().setLayer('Facsimile', page);
        this.pv.addPanel().setLayer(this.currentTextLayer);
        return this.pv.renderPanels();
      };

      Home.prototype.printEntry = function(e) {
        e.preventDefault();
        return window.print();
      };

      Home.prototype.ifEscapeClose = function(e) {
        return console.log("DUNO");
      };

      Home.prototype.positionTextView = function() {
        return this.$('.text-view').css({
          'background-color': 'yellow'
        });
      };

      Home.prototype.renderMetadata = function() {
        var metadata;
        metadata = this.model.get('metadata') || [];
        this.$('.metadata').html(this.metadataTemplate({
          metadata: metadata
        }));
        if (configData.get('showMetaData')) {
          this.toggleMoreMetadata();
        }
        return this;
      };

      Home.prototype.renderHeader = function() {
        var next, prev;
        this.$('.header').html(this.headerTemplate({
          config: config,
          entry: this.model.attributes,
          entries: configData
        }));
        prev = configData.findPrev(this.model.id);
        if (prev) {
          this.$('.prev').attr({
            href: config.entryURL(prev)
          });
        }
        next = configData.findNext(this.model.id);
        if (next) {
          this.$('.next').attr({
            href: config.entryURL(next)
          });
        }
        this.$('.prev-entry').toggleClass('hide', !prev);
        this.$('.next-entry').toggleClass('hide', !next);
        return this.renderResultsNavigation();
      };

      Home.prototype.renderResultsNavigation = function() {
        var id, ids, nextId, prevId, showResultsNav, _ref1, _ref2;
        ids = configData.get('allResultIds');
        showResultsNav = (ids != null ? ids.length : void 0) > 0 && ids.indexOf(String(this.model.id)) !== -1;
        this.$('.navigate-results').toggle(showResultsNav);
        if (ids != null ? ids.length : void 0) {
          id = this.model.id;
          prevId = (_ref1 = ids[ids.indexOf(String(id)) - 1]) != null ? _ref1 : null;
          nextId = (_ref2 = ids[ids.indexOf(String(id)) + 1]) != null ? _ref2 : null;
          console.log(prevId, nextId);
          this.$('.navigate-results .prev-result').toggle(prevId != null).attr({
            href: config.entryURL(prevId)
          });
          this.$('.navigate-results .next-result').toggle(nextId != null).attr({
            href: config.entryURL(nextId)
          });
          this.$('.navigate-results .idx').text(ids.indexOf(String(id)) + 1);
          return this.$('.navigate-results .total').text(ids.length);
        }
      };

      Home.prototype.renderContents = function() {
        this.$('.contents').html(this.contentsTemplate({
          entry: this.model.attributes,
          config: config,
          configData: configData
        }));
        this.textView = new TextView({
          model: this.model,
          layer: this.currentTextLayer,
          el: this.$('.contents .text-view')
        });
        if (this.options.annotation != null) {
          return this.textView.highlightAnnotation(this.options.annotation);
        }
      };

      Home.prototype.renderEntry = function() {
        this.renderHeader();
        this.renderMetadata();
        this.renderContents();
        return this.setActiveTextLayer(this.currentTextLayer);
      };

      Home.prototype.render = function() {
        this.$el.html(this.baseTemplate());
        this.renderEntry();
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
