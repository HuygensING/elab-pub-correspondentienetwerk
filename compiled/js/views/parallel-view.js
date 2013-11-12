(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseView, Entry, PanelView, ParallelView, Templates, _ref;
    BaseView = require('views/base');
    PanelView = require('views/panel');
    Entry = require('models/entry');
    Templates = {
      ParallelView: require('text!html/parallel-view.html')
    };
    return ParallelView = (function(_super) {
      __extends(ParallelView, _super);

      function ParallelView() {
        _ref = ParallelView.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ParallelView.prototype.className = 'parallel-view';

      ParallelView.prototype.events = {
        'click .add': 'addPanelEvent',
        'click .panel .close': 'closePanel',
        'click button.close': 'closeParallelView'
      };

      ParallelView.prototype.initialize = function(options) {
        var _this = this;
        this.options = options;
        ParallelView.__super__.initialize.apply(this, arguments);
        this.panels = [];
        if ('id' in this.options) {
          this.model = new Entry({
            id: this.options.id
          });
          this.model.fetch({
            success: function() {
              return _this.render();
            }
          });
        }
        this.addPanel();
        return this.render();
      };

      ParallelView.prototype.closeParallelView = function() {
        return this.hide();
      };

      ParallelView.prototype.show = function() {
        return this.$el.show();
      };

      ParallelView.prototype.hide = function() {
        return this.$el.hide();
      };

      ParallelView.prototype.closePanel = function(e) {
        var pNumber, panel;
        pNumber = $(e.currentTarget).closest('.panel-frame').index();
        panel = this.panels.splice(pNumber, 1)[0];
        panel.remove();
        return this.repositionPanels();
      };

      ParallelView.prototype.addPanelEvent = function(e) {
        var last, lastPanel, po, removeNew;
        this.addPanel();
        last = this.panels.length - 1;
        lastPanel = this.panels[last];
        this.appendPanel(lastPanel);
        lastPanel.$('.panel').addClass('new');
        removeNew = function() {
          return lastPanel.$('.panel').removeClass('new');
        };
        setTimeout(removeNew, 1500);
        po = this.$('.parallel-overlay');
        return po.animate({
          scrollLeft: po[0].scrollWidth - po[0].clientWidth
        });
      };

      ParallelView.prototype.addPanel = function() {
        var panel;
        panel = new PanelView({
          model: this.model
        });
        this.panels.push(panel);
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
        this.positionPanel(p, this.panels.length - 1);
        return p.positionSelectionTab();
      };

      ParallelView.prototype.clearPanels = function() {
        this.panels = [];
        return this.renderPanels();
      };

      ParallelView.prototype.renderPanels = function() {
        var p, pos, _i, _len, _ref1, _results;
        this.$('.panel-container').empty();
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
        this.renderPanels();
        return this;
      };

      return ParallelView;

    })(BaseView);
  });

}).call(this);
