(function() {
  define(function(require) {
    var basePath, config, us;
    us = require('underscore.string');
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
      entryURL: function(id, textLayer, annotation) {
        var base;
        base = "/entry/" + id;
        if ((annotation != null) && (textLayer != null)) {
          return "" + base + "/" + (us.slugify(textLayer)) + "/" + annotation;
        } else if (textLayer != null) {
          return "" + base + "/" + (us.slugify(textLayer));
        } else {
          return base;
        }
      },
      entryDataURL: function(id) {
        return "" + basePath + "/data/" + id + ".json";
      },
      parallelURL: function(id) {
        return "/entry/" + id + "/parallel";
      },
      defaultTextLayer: 'Diplomatic',
      resultRows: 25,
      panelSize: 'large',
      searchPath: "" + basePath + "/api/search"
    };
    return config;
  });

}).call(this);
