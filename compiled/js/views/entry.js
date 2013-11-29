(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Entry, KEYCODE_ESCAPE, ParallelView, TextView, config, events, _ref;
    config = require('config');
    events = require('events');
    BaseView = require('views/base');
    TextView = require('views/text');
    ParallelView = require('views/parallel-view');
    Entry = require('models/entry');
    KEYCODE_ESCAPE = 27;
    return Entry = (function(_super) {
      __extends(Entry, _super);

      function Entry() {
        _ref = Entry.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Entry.prototype.baseTemplate = require('text!html/entry/base.html');

      Entry.prototype.headerTemplate = require('text!html/entry/header.html');

      Entry.prototype.metadataTemplate = require('text!html/entry/metadata.html');

      Entry.prototype.contentsTemplate = require('text!html/entry/contents.html');

      Entry.prototype.className = 'entry';

      Entry.prototype.events = {
        'click .layers li': 'changeTextLayer',
        'click .more button': 'toggleMoreMetadata',
        'click .parallel button': 'showParallelView',
        'click .thumbnail': 'showThumbnailParallelView',
        'click a.print': 'printEntry'
      };

      Entry.prototype.initialize = function(options) {
        var doCheck,
          _this = this;
        this.options = options != null ? options : {};
        Entry.__super__.initialize.apply(this, arguments);
        this.baseTemplate = _.template(this.baseTemplate);
        this.headerTemplate = _.template(this.headerTemplate);
        this.metadataTemplate = _.template(this.metadataTemplate);
        this.contentsTemplate = _.template(this.contentsTemplate);
        this.currentTextLayer = this.options.layerSlug != null ? config.slugToLayer(this.options.layerSlug) : this.options.layer != null ? this.options.layer : config.get('textLayer');
        console.log("Show args", this.options);
        $(document).keyup(function(e) {
          return _this.ifEscapeClose(e);
        });
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

      Entry.prototype.setActiveTextLayer = function(layer) {
        var li;
        li = this.$(".layers li[data-toggle=" + layer + "]");
        return li.addClass('active').siblings().removeClass('active');
      };

      Entry.prototype.changeTextLayer = function(e) {
        this.currentTextLayer = $(e.currentTarget).data('toggle');
        this.setActiveTextLayer(this.currentTextLayer);
        this.textView.setView(this.currentTextLayer);
        return config.set({
          textLayer: this.currentTextLayer
        });
      };

      Entry.prototype.toggleMoreMetadata = function(e) {
        var show;
        show = !$(e.currentTarget).hasClass('more');
        this.showMoreMetaData(show, true);
        return config.set({
          showMetaData: show
        });
      };

      Entry.prototype.showMoreMetaData = function(show, animate) {
        if (animate == null) {
          animate = false;
        }
        if (show) {
          this.$('.metadata').addClass('more');
          this.$('.metadata button').addClass('more');
          return this.$('.metadata li').show();
        } else {
          this.$('.metadata').removeClass('more');
          this.$('.metadata button').removeClass('more');
          return this.$('.metadata li').show().filter(function(idx) {
            if (idx > 3) {
              return $(this).hide();
            }
          });
        }
      };

      Entry.prototype.showParallelView = function(opts) {
        if (opts == null) {
          opts = {};
        }
        _.extend(opts, {
          model: this.model
        });
        this.pv = new ParallelView(opts);
        this.$('.parallel-view-container').empty().html(this.pv.el);
        this.pv.show();
        return this.pv;
      };

      Entry.prototype.showThumbnailParallelView = function(e) {
        var page, target;
        target = $(e.currentTarget);
        page = target.data('page');
        this.pv = this.showParallelView({
          panels: [
            {
              textLayer: 'Facsimile',
              page: page
            }, {
              textLayer: this.currentTextLayer
            }
          ]
        });
        return this.pv.repositionPanels();
      };

      Entry.prototype.printEntry = function(e) {
        e.preventDefault();
        return window.print();
      };

      Entry.prototype.close = function() {};

      Entry.prototype.ifEscapeClose = function(e) {
        if (e.keyCode === KEYCODE_ESCAPE) {
          return this.close();
        }
      };

      Entry.prototype.positionTextView = function() {
        return this.$('.text-view').css({
          'background-color': 'yellow'
        });
      };

      Entry.prototype.renderMetadata = function() {
        var metadata;
        metadata = this.model.get('metadata') || [];
        this.$('.metadata').html(this.metadataTemplate({
          metadata: metadata
        }));
        if (config.get('showMetaData') != null) {
          this.showMoreMetaData(config.get('showMetaData'));
        } else {
          this.showMoreMetaData(false);
        }
        return this;
      };

      Entry.prototype.renderHeader = function() {
        var next, prev;
        this.$('.header').html(this.headerTemplate({
          config: config,
          entry: this.model.attributes
        }));
        prev = config.findPrev(this.model.id);
        if (prev) {
          this.$('.prev').attr({
            href: config.entryURL(prev)
          });
        }
        next = config.findNext(this.model.id);
        if (next) {
          this.$('.next').attr({
            href: config.entryURL(next)
          });
        }
        this.$('.prev-entry').toggleClass('hide', !prev);
        this.$('.next-entry').toggleClass('hide', !next);
        return this.renderResultsNavigation();
      };

      Entry.prototype.renderResultsNavigation = function() {
        var id, ids, nextId, prevId, showResultsNav, _ref1, _ref2;
        ids = config.get('allResultIds');
        showResultsNav = (ids != null ? ids.length : void 0) > 0 && ids.indexOf(String(this.model.id)) !== -1;
        this.$('.navigate-results').toggle(showResultsNav);
        if (ids != null ? ids.length : void 0) {
          id = this.model.id;
          prevId = (_ref1 = ids[ids.indexOf(String(id)) - 1]) != null ? _ref1 : null;
          nextId = (_ref2 = ids[ids.indexOf(String(id)) + 1]) != null ? _ref2 : null;
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

      Entry.prototype.renderContents = function() {
        this.$('.contents').html(this.contentsTemplate({
          entry: this.model.attributes,
          config: config
        }));
        this.textView = new TextView({
          model: this.model,
          layer: this.currentTextLayer,
          el: this.$('.contents .text-view')
        });
        if (this.options.annotation != null) {
          console.log("Highlighting " + this.options.annotation + "!");
          return this.textView.highlightAnnotation(this.options.annotation);
        }
      };

      Entry.prototype.renderEntry = function() {
        this.renderHeader();
        this.renderMetadata();
        this.renderContents();
        return this.setActiveTextLayer(this.currentTextLayer);
      };

      Entry.prototype.render = function() {
        this.$el.html(this.baseTemplate());
        this.renderEntry();
        return this;
      };

      return Entry;

    })(BaseView);
  });

}).call(this);
