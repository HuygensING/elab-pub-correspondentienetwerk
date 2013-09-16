(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Home, Item, ParallelView, TextView, config, configData, _ref;
    configData = require('models/configdata');
    config = require('config');
    BaseView = require('views/base');
    TextView = require('views/text');
    ParallelView = require('views/parallel-view');
    Item = require('models/item');
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.baseTemplate = require('text!html/item/base.html');

      Home.prototype.headerTemplate = require('text!html/item/header.html');

      Home.prototype.metadataTemplate = require('text!html/item/metadata.html');

      Home.prototype.contentsTemplate = require('text!html/item/contents.html');

      Home.prototype.events = {
        'click .versions li': 'changeTextVersion',
        'click .more button': 'toggleMoreMetadata',
        'click .parallel button': 'showParallelView'
      };

      Home.prototype.setActiveTextVersion = function(version) {
        var li;
        li = this.$(".versions li[data-toggle=" + version + "]");
        return li.addClass('active').siblings().removeClass('active');
      };

      Home.prototype.changeTextVersion = function(e) {
        this.currentTextVersion = $(e.currentTarget).data('toggle');
        this.setActiveTextVersion(this.currentTextVersion);
        return this.textView.setView(this.currentTextVersion);
      };

      Home.prototype.toggleMoreMetadata = function(e) {
        this.$('.metadata').toggleClass('more');
        return $(e.currentTarget).toggleClass('more');
      };

      Home.prototype.showParallelView = function(e) {
        if (!this.pv) {
          this.pv = new ParallelView({
            model: this.model
          });
          return this.$('.header').after(this.pv.el);
        } else {
          return this.pv.show();
        }
      };

      Home.prototype.initialize = function() {
        var _this = this;
        Home.__super__.initialize.apply(this, arguments);
        this.baseTemplate = _.template(this.baseTemplate);
        this.headerTemplate = _.template(this.headerTemplate);
        this.metadataTemplate = _.template(this.metadataTemplate);
        this.contentsTemplate = _.template(this.contentsTemplate);
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
        if (!this.options.mode) {
          this.options.mode = 'normal';
        }
        this.currentTextVersion = this.options.version || config.defaultTextVersion;
        this.numMetadataItems = this.options.numMetadataItems || 4;
        return this.render();
      };

      Home.prototype.renderMetadata = function() {
        var metadata;
        metadata = this.model.get('metadata') || [];
        this.$('.metadata').html(this.metadataTemplate({
          metadata: metadata
        }));
        return this;
      };

      Home.prototype.renderHeader = function() {
        var next, prev;
        this.$('.header').html(this.headerTemplate({
          item: this.model.attributes
        }));
        prev = configData.findPrev(this.options.id);
        if (prev) {
          this.$('.prev').attr({
            href: config.itemURL(prev)
          });
        }
        next = configData.findNext(this.options.id);
        if (next) {
          this.$('.next').attr({
            href: config.itemURL(next)
          });
        }
        this.$('.prev').toggleClass('hide', !prev);
        return this.$('.next').toggleClass('hide', !next);
      };

      Home.prototype.renderContents = function() {
        this.$('.contents').html(this.contentsTemplate({
          item: this.model.attributes,
          config: config
        }));
        return this.textView = new TextView({
          model: this.model,
          version: this.currentTextVersion,
          el: this.$('.contents .text-view')
        });
      };

      Home.prototype.renderItem = function() {
        this.renderHeader();
        this.renderMetadata();
        this.renderContents();
        return this.setActiveTextVersion(this.currentTextVersion);
      };

      Home.prototype.render = function() {
        this.$el.html(this.baseTemplate());
        this.renderItem();
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
