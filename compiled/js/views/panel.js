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

      PanelView.prototype.className = 'panel';

      PanelView.prototype.template = require('text!html/panel.html');

      PanelView.prototype.events = {
        'click .selection li': 'selectText'
      };

      PanelView.prototype.initialize = function(options) {
        var _ref1,
          _this = this;
        this.options = options;
        this.template = _.template(this.template);
        this.textVersion = ((_ref1 = this.options) != null ? _ref1.textVersion : void 0) || 'Translation';
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

      PanelView.prototype.selectText = function(e) {
        var target;
        target = $(e.currentTarget);
        return this.setVersion(target.data('toggle'));
      };

      PanelView.prototype.versionIsFacsimile = function() {
        return this.textVersion === 'Facsimile';
      };

      PanelView.prototype.setVersion = function(version, page) {
        if (page == null) {
          page = null;
        }
        this.textVersion = version;
        if (this.versionIsFacsimile()) {
          this.page = page;
        }
        return this.renderContent();
      };

      PanelView.prototype.selectedVersion = function() {
        return this.textVersion;
      };

      PanelView.prototype.positionSelectionTab = function() {
        var ml, mt;
        ml = this.$('.selection').outerWidth() / 2;
        mt = this.$('.selection').outerHeight();
        return this.$('.selection').css({
          left: '50%',
          'margin-left': "-" + ml + "px",
          'margin-top': "-" + mt + "px"
        });
      };

      PanelView.prototype.renderCurrentSelection = function() {
        return this.$('.selection .current span').text(this.textVersion);
      };

      PanelView.prototype.renderContent = function() {
        if (this.versionIsFacsimile()) {
          this.subView = new FacsimileView({
            model: this.model,
            page: this.page
          });
          return this.$('.view').html(this.subView.el);
        } else {
          this.subView = new TextView({
            model: this.model,
            version: this.textVersion
          });
          return this.$('.view').html(this.subView.el);
        }
      };

      PanelView.prototype.render = function() {
        var _ref1;
        this.$el.html(this.template({
          entry: (_ref1 = this.model) != null ? _ref1.attributes : void 0,
          versions: _.flatten(['Facsimile', this.model.textVersions()]),
          version: this.textVersion
        }));
        this.renderCurrentSelection();
        this.renderContent();
        this.$el.addClass(config.panelSize);
        this.positionSelectionTab();
        return this;
      };

      return PanelView;

    })(Backbone.View);
  });

}).call(this);
