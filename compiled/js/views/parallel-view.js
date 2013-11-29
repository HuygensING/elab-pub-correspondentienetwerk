(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Entry, KEYCODE_ESCAPE, PanelView, ParallelView, Templates, config, _ref;
    BaseView = require('views/base');
    PanelView = require('views/panel');
    Entry = require('models/entry');
    config = require('config');
    Templates = {
      ParallelView: require('text!html/parallel-view.html')
    };
    KEYCODE_ESCAPE = 27;
    return ParallelView = (function(_super) {
      __extends(ParallelView, _super);

      function ParallelView() {
        _ref = ParallelView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ParallelView.prototype.className = 'parallel-view';

      ParallelView.prototype.events = {
        'click .add': 'scrollToEnd',
        'click .panel .close': 'closePanel',
        'click button.close': 'closeParallelView',
        'keydown *': 'ifEscapeClose'
      };

      ParallelView.prototype.initialize = function(options) {
        var opts, preLoad, _i, _len,
          _this = this;
        this.options = options != null ? options : {};
        ParallelView.__super__.initialize.apply(this, arguments);
        $(document).keyup(function(e) {
          return _this.ifEscapeClose(e);
        });
        this.textLayers = _.flatten(['Facsimile', config.get('textLayers')]);
        this.panels = [];
        preLoad = this.options.panels || config.get('parallelPanels');
        if (preLoad) {
          for (_i = 0, _len = preLoad.length; _i < _len; _i++) {
            opts = preLoad[_i];
            _.extend(opts, {
              model: this.model
            });
            this.addPanel(new PanelView(opts));
          }
        }
        return this.render();
      };

      ParallelView.prototype.ifEscapeClose = function(e) {
        if (e.keyCode === KEYCODE_ESCAPE) {
          return this.closeParallelView();
        }
      };

      ParallelView.prototype.closeParallelView = function() {
        var _this = this;
        this.$('.parallel-controls').css({
          position: 'relative'
        });
        return this.$('.parallel-overlay').animate({
          left: '-100%',
          opacity: 0
        }, 250, function() {
          return _this.remove();
        });
      };

      ParallelView.prototype.show = function() {
        var _this = this;
        this.$el.show();
        this.$('.parallel-controls').css({
          position: 'relative'
        });
        return this.$('.parallel-overlay').css({
          left: '100%',
          opacity: '0'
        }).animate({
          left: '0%',
          opacity: '1'
        }, 150, function() {
          return _this.$('.parallel-controls').css({
            position: 'fixed'
          });
        });
      };

      ParallelView.prototype.hide = function() {
        return this.$el.hide();
      };

      ParallelView.prototype.closePanel = function(e) {
        var pNumber, panel;
        pNumber = $(e.currentTarget).closest('.panel-frame').index();
        panel = this.panels.splice(pNumber, 1)[0];
        panel.remove();
        this.repositionPanels();
        if (_.last(this.panels).selectedLayer()) {
          this.renderPanels();
          this.renderAddButton();
          this.scrollToEnd();
        } else {
          _.last(this.panels).setAvailableLayers(this.availableLayers()).render();
        }
        return this.renderAddButton();
      };

      ParallelView.prototype.scrollToEnd = function() {
        var po;
        po = this.$('.parallel-overlay');
        return po.animate({
          scrollLeft: (po[0].scrollWidth - po[0].clientWidth + 1200) + 'px'
        });
      };

      ParallelView.prototype.layerSelected = function() {
        this.renderAddButton();
        this.renderPanels();
        return this.scrollToEnd();
      };

      ParallelView.prototype.addPanel = function(panel) {
        if (panel == null) {
          panel = new PanelView({
            model: this.model
          });
        }
        this.panels.push(panel);
        this.listenTo(panel, 'layer-selected', this.layerSelected);
        return panel;
      };

      ParallelView.prototype.availableLayers = function() {
        var availableLayers, usedLayers;
        usedLayers = _.map(this.panels, function(p) {
          return p.selectedLayer();
        });
        return availableLayers = _.difference(this.textLayers, usedLayers);
      };

      ParallelView.prototype.emptyPanel = function() {
        var panel;
        panel = new PanelView({
          model: this.model,
          layers: this.availableLayers()
        });
        return panel;
      };

      ParallelView.prototype.positionPanel = function(p, pos) {
        if (pos == null) {
          pos = 0;
        }
        return p.$el.css({
          top: 0,
          left: (pos * p.$el.outerWidth()) + 'px'
        });
      };

      ParallelView.prototype.repositionPanels = function() {
        var p, pos, _i, _len, _ref1, _results;
        _ref1 = this.panels;
        _results = [];
        for (pos = _i = 0, _len = _ref1.length; _i < _len; pos = ++_i) {
          p = _ref1[pos];
          _results.push(p.$el.css({
            left: (pos * p.$el.outerWidth()) + 'px'
          }));
        }
        return _results;
      };

      ParallelView.prototype.panel = function(idx) {
        return this.panels[idx];
      };

      ParallelView.prototype.appendPanel = function(p) {
        this.$('.panel-container').append(p.el);
        p.$el.css({
          height: '200px'
        });
        return this.positionPanel(p, this.panels.length - 1);
      };

      ParallelView.prototype.clearPanels = function() {
        this.panels = [];
        return this.renderPanels();
      };

      ParallelView.prototype.renderAddButton = function() {
        var addButton, noLayers;
        noLayers = this.availableLayers().length === 0;
        addButton = this.$('.parallel-controls button.add');
        if (noLayers) {
          return addButton.attr('disabled', 'disabled');
        } else {
          return addButton.removeAttr('disabled');
        }
      };

      ParallelView.prototype.renderPanels = function() {
        var p, pos, _i, _len, _ref1, _results;
        this.$('.panel-container').empty();
        if (this.availableLayers().length) {
          this.addPanel(this.emptyPanel());
        }
        _ref1 = this.panels;
        _results = [];
        for (pos = _i = 0, _len = _ref1.length; _i < _len; pos = ++_i) {
          p = _ref1[pos];
          this.appendPanel(p);
          _results.push(this.positionPanel(p, pos));
        }
        return _results;
      };

      ParallelView.prototype.render = function() {
        var tmpl, _ref1;
        tmpl = _.template(Templates.ParallelView);
        this.$el.html(tmpl({
          entry: (_ref1 = this.model) != null ? _ref1.attributes : void 0
        }));
        this.$('.title').text(this.model.get('name'));
        this.renderPanels();
        return this;
      };

      return ParallelView;

    })(BaseView);
  });

}).call(this);
