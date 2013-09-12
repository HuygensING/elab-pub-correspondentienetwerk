(function() {
  define(function(require) {
    var config;
    return config = {
      appRootElement: '#app',
      baseURL: '',
      itemURL: function(id) {
        return "/item/" + (String(id).replace('.json', ''));
      },
      parallelURL: function(id) {
        return "/item/" + id + "/parallel";
      },
      defaultTextVersion: 'Diplomatic',
      resultRows: 10,
      panelSize: 'large',
      searchPath: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search'
    };
  });

}).call(this);
