(function() {
  define(function(require) {
    var Backbone, Pubsub, Token, _;
    Backbone = require('backbone');
    _ = require('underscore');
    Pubsub = require('managers/pubsub');
    Token = (function() {
      Token.prototype.token = null;

      function Token() {
        _.extend(this, Backbone.Events);
        _.extend(this, Pubsub);
      }

      Token.prototype.set = function(token) {
        this.token = token;
        return sessionStorage.setItem('huygens_token', token);
      };

      Token.prototype.get = function() {
        if (this.token == null) {
          this.token = sessionStorage.getItem('huygens_token');
        }
        if (this.token == null) {
          this.publish('unauthorized');
          return false;
        }
        return this.token;
      };

      Token.prototype.clear = function() {
        return sessionStorage.removeItem('huygens_token');
      };

      return Token;

    })();
    return new Token();
  });

}).call(this);
