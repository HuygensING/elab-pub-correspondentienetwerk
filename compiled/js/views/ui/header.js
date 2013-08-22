(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var Header, Templates, Views, _ref;
    Views = {
      Base: require('views/base')
    };
    Templates = {
      Header: require('text!html/ui/header.html')
    };
    return Header = (function(_super) {
      __extends(Header, _super);

      function Header() {
        _ref = Header.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      Header.prototype.tagName = 'header';

      Header.prototype.initialize = function() {
        Header.__super__.initialize.apply(this, arguments);
        return this.render();
      };

      Header.prototype.render = function() {
        var rtpl;
        rtpl = _.template(Templates.Header);
        this.$el.html(rtpl);
        return this;
      };

      return Header;

    })(Views.Base);
  });

}).call(this);
