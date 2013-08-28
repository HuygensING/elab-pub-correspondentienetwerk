(function() {
  define(function(require) {
    var config;
    return config = {
      appRootElement: '#app',
      baseURL: '',
      itemURL: function(id) {
        return "/item/" + (String(id).replace('.json', ''));
      }
    };
  });

}).call(this);
