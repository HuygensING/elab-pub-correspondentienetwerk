(function() {
  define(function(require) {
    var basePath, config;
    basePath = window.location.pathname;
    basePath = basePath.replace(/(?:\/entry(?:\/[^\/]*)+)+/, '/');
    console.log("BASE PATH", basePath);
    config = {
      appRootElement: '#app',
      baseURL: '',
      configDataURL: "" + basePath + "data/config.json",
      itemLabel: 'entry',
      itemLabelPlural: 'entries',
      entryURL: function(id) {
        return "" + basePath + "entry/" + id;
      },
      entryDataURL: function(id) {
        console.log("Fetching entry " + id);
        return "" + basePath + "data/" + id + ".json";
      },
      parallelURL: function(id) {
        return "" + basePath + "entry/" + id + "/parallel";
      },
      defaultTextVersion: 'Diplomatic',
      resultRows: 10,
      panelSize: 'large',
      searchPath: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search'
    };
    console.log(config);
    return config;
  });

}).call(this);
