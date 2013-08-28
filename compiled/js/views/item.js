(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Home, Item, Templates, config, configData, _ref;
    configData = require('models/configdata');
    config = require('config');
    BaseView = require('views/base');
    Item = require('models/item');
    Templates = {
      Home: require('text!html/item.html'),
      Metadata: require('text!html/metadata.html'),
      Annotations: require('text!html/annotations.html')
    };
    return Home = (function(_super) {
      __extends(Home, _super);

      function Home() {
        _ref = Home.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Home.prototype.events = {
        'click .versions li button': 'changeTextVersion',
        'click .more button': 'toggleMoreMetadata'
      };

      Home.prototype.changeTextVersion = function(e) {
        this.currentTextVersion = $(e.currentTarget).data('toggle');
        return this.renderContent();
      };

      Home.prototype.toggleMoreMetadata = function(e) {
        var more, _ref1;
        more = !$(e.currentTarget).hasClass('more');
        $(e.currentTarget).toggleClass('more');
        if (more) {
          this.numMetadataItems = (_ref1 = this.model.get('metadata')) != null ? _ref1.length : void 0;
        } else {
          this.numMetadataItems = 4;
        }
        return this.renderMetadata();
      };

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
        this.currentTextVersion = 'Translation';
        this.numMetadataItems = 4;
        return this.render();
      };

      Home.prototype.renderAnnotations = function() {
        var annotations, tmpl;
        annotations = this.model.annotations(this.currentTextVersion);
        tmpl = _.template(Templates.Annotations);
        this.$('.contents .annotations .padder').html(tmpl({
          annotations: annotations
        }));
        return this;
      };

      Home.prototype.renderMetadata = function() {
        var metadata, tmpl;
        tmpl = _.template(Templates.Metadata);
        metadata = this.model.get('metadata') || [];
        this.$('.metadata .span8').html(tmpl({
          metadata: metadata.slice(0, +(this.numMetadataItems - 1) + 1 || 9e9)
        }));
        return this;
      };

      Home.prototype.renderContent = function() {
        var text;
        text = this.model.text(this.currentTextVersion);
        this.$('.contents .text').html(text);
        this.renderAnnotations();
        return this;
      };

      Home.prototype.renderNavigation = function() {
        var next, prev;
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

      Home.prototype.render = function() {
        var item, rtpl;
        rtpl = _.template(Templates.Home);
        this.$el.html(rtpl({
          item: {}
        }));
        item = this.model.attributes;
        if ('name' in item) {
          this.$el.html(rtpl({
            item: item
          }));
        }
        this.renderNavigation();
        this.renderMetadata();
        this.renderAnnotations();
        return this;
      };

      return Home;

    })(BaseView);
  });

}).call(this);
