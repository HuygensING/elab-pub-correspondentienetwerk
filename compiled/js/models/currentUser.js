(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(function(require) {
    var BaseModel, CurrentUser, _ref;
    BaseModel = require('models/base');
    CurrentUser = (function(_super) {
      __extends(CurrentUser, _super);

      function CurrentUser() {
        _ref = CurrentUser.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      return CurrentUser;

    })(BaseModel);
    return new CurrentUser();
  });

}).call(this);
