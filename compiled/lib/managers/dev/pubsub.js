(function() {
  define(function(require) {
    var Backbone;
    Backbone = require('backbone');
    return {
      subscribe: function(ev, cb) {
        return this.listenTo(Backbone, ev, cb);
      },
      publish: function() {
        return Backbone.trigger.apply(Backbone, arguments);
      }
    };
  });

}).call(this);
