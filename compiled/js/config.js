(function() {
  define(function(require) {
    var basePath, config;
    basePath = BASE_URL;
    if (basePath === '/') {
      basePath = '';
    }
    config = {
      basePath: basePath,
      annotationsIndex: "" + basePath + "/data/annotation_index.json",
      configDataURL: "" + basePath + "/data/config.json",
      itemLabel: 'entry',
      itemLabelPlural: 'entries',
      entryURL: function(id) {
        return "/entry/" + id;
      },
      entryDataURL: function(id) {
        return "" + basePath + "/data/" + id + ".json";
      },
      parallelURL: function(id) {
        return "/entry/" + id + "/parallel";
      },
      defaultTextVersion: 'Diplomatic',
      resultRows: 10,
      panelSize: 'large',
      searchPath: "http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search"
    };
    return config;
  });

}).call(this);
