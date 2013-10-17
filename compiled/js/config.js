(function() {
  define(function(require) {
    var basePath, config;
    basePath = BASE_URL;
    if (basePath === '/') {
      basePath = '';
    }
    config = {
      configDataURL: "" + basePath + "/data/config.json",
      itemLabel: 'entry',
      itemLabelPlural: 'entries',
      entryURL: function(id) {
        return "" + basePath + "/entry/" + id;
      },
      entryDataURL: function(id) {
        console.log("Fetching entry " + id);
        return "" + basePath + "/data/" + id + ".json";
      },
      parallelURL: function(id) {
        return "" + basePath + "/entry/" + id + "/parallel";
      },
      defaultTextVersion: 'Diplomatic',
      resultRows: 10,
      panelSize: 'large',
      searchPath: "" + basePath + "/api/search"
    };
    return config;
  });

}).call(this);
