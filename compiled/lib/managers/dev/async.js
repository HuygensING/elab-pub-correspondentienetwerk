(function() {
  define(function(require) {
    var Async, _;
    _ = require('underscore');
    return Async = (function() {
      function Async(names) {
        if (names == null) {
          names = [];
        }
        _.extend(this, Backbone.Events);
        this.callbacksCalled = {};
        this.register(names);
      }

      Async.prototype.register = function(names) {
        var name, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = names.length; _i < _len; _i++) {
          name = names[_i];
          _results.push(this.callbacksCalled[name] = false);
        }
        return _results;
      };

      Async.prototype.called = function(name, data) {
        if (data == null) {
          data = true;
        }
        this.callbacksCalled[name] = data;
        if (_.every(this.callbacksCalled, function(called) {
          return called !== false;
        })) {
          return this.ready();
        }
      };

      Async.prototype.ready = function() {
        return this.trigger('ready', this.callbacksCalled);
      };

      return Async;

    })();
  });

}).call(this);
