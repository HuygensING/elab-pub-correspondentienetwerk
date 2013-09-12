(function() {
  define(function(require) {
    var Backbone, History, _;
    Backbone = require('backbone');
    _ = require('underscore');
    History = (function() {
      function History() {}

      History.prototype.history = [];

      History.prototype.update = function() {
        this.history.push(window.location.pathname);
        return sessionStorage.setItem('history', JSON.stringify(this.history));
      };

      History.prototype.clear = function() {
        return sessionStorage.removeItem('history');
      };

      History.prototype.last = function() {
        return this.history[this.history.length - 1];
      };

      return History;

    })();
    return new History();
  });

}).call(this);
