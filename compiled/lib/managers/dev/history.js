(function() {
  define(function(require) {
    var Backbone, History, Pubsub, _;
    Backbone = require('backbone');
    _ = require('underscore');
    Pubsub = require('managers/pubsub');
    History = (function() {
      History.prototype.history = [];

      function History() {
        _.extend(this, Backbone.Events);
        _.extend(this, Pubsub);
      }

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
