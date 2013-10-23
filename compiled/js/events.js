(function() {
  define(function(require) {
    var Backbone, events;
    Backbone = require('backbone');
    events = {};
    _.extend(events, Backbone.Events);
    return events;
  });

}).call(this);
