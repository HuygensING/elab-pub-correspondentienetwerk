(function() {
  define(function(require) {
    var basePath, config;
    basePath = window.location.pathname;
    config = {
      appRootElement: '#app',
      baseURL: '',
      configDataURL: "" + basePath + "data/config.json",
      itemURL: function(id) {
        return "item/" + (String(id).replace('.json', ''));
      },
      parallelURL: function(id) {
        return "" + basePath + "item/" + id + "/parallel";
      },
      defaultTextVersion: 'Diplomatic',
      resultRows: 10,
      panelSize: 'large',
      searchPath: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search'
    };
    config.basePath = basePath;
    return config;
  });

}).call(this);
