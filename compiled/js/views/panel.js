(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Entry, FacsimileView, PanelView, TextView, config, _ref;
    config = require('config');
    Entry = require('models/entry');
    TextView = require('views/text');
    FacsimileView = require('views/facsimile');
    return PanelView = (function(_super) {
      __extends(PanelView, _super);

      function PanelView() {
        _ref = PanelView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      PanelView.prototype.className = 'panel-frame';

      PanelView.prototype.template = require('text!html/panel.html');

      PanelView.prototype.events = {
        'click .select-layer li': 'selectLayer'
      };

      PanelView.prototype.initialize = function(options) {
        var _ref1,
          _this = this;
        this.options = options;
        this.template = _.template(this.template);
        this.textLayer = (_ref1 = this.options) != null ? _ref1.textLayer : void 0;
        this.layers = this.options.layers;
        if ('id' in this.options && !this.model) {
          this.model = new Entry({
            id: this.options.id
          });
          return this.model.fetch({
            success: function() {
              return _this.render();
            }
          });
        } else if (this.model) {
          return this.render();
        }
      };

      PanelView.prototype.selectLayer = function(e) {
        var layer, removeNew, target;
        target = $(e.currentTarget);
        layer = target.data('toggle');
        this.setLayer(layer);
        this.trigger('layer-selected', layer);
        this.$('.panel').addClass('new');
        removeNew = function() {
          return this.$('.panel').removeClass('new');
        };
        return setTimeout(removeNew, 1000);
      };

      PanelView.prototype.layerIsFacsimile = function() {
        return this.textLayer === 'Facsimile';
      };

      PanelView.prototype.setLayer = function(layer, page) {
        if (page == null) {
          page = null;
        }
        this.textLayer = layer;
        if (this.layerIsFacsimile()) {
          this.page = page;
        }
        return this.renderContent();
      };

      PanelView.prototype.setAvailableLayers = function(layers) {
        this.layers = layers != null ? layers : [];
        return this;
      };

      PanelView.prototype.selectedLayer = function() {
        return this.textLayer;
      };

      PanelView.prototype.renderCurrentSelection = function() {
        return this.$('.selection .current span').text(this.textLayer);
      };

      PanelView.prototype.renderContent = function() {
        if (this.layerIsFacsimile()) {
          this.subView = new FacsimileView({
            model: this.model,
            page: this.page
          });
        } else if (this.textLayer) {
          this.subView = new TextView({
            model: this.model,
            layer: this.textLayer
          });
        }
        if (this.subView != null) {
          this.$('.view').html(this.subView.el);
          this.$('.close').show();
        }
        return this.$('.layer').text(this.textLayer);
      };

      PanelView.prototype.render = function() {
        var _ref1;
        this.$el.html(this.template({
          entry: (_ref1 = this.model) != null ? _ref1.attributes : void 0,
          layers: this.layers,
          layer: this.textLayer
        }));
        this.$('.close').hide();
        this.$el.toggleClass('select', this.textLayer == null);
        this.renderCurrentSelection();
        this.renderContent();
        this.$el.addClass(config.panelSize);
        return this;
      };

      return PanelView;

    })(Backbone.View);
  });

}).call(this);
