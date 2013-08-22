(function() {
  define(function(require) {
    var $;
    $ = require('jquery');
    $.support.cors = true;
    return {
      token: null,
      get: function(args) {
        return this.fire('get', args);
      },
      post: function(args) {
        return this.fire('post', args);
      },
      put: function(args) {
        return this.fire('put', args);
      },
      fire: function(type, args) {
        var ajaxArgs,
          _this = this;
        ajaxArgs = {
          type: type,
          dataType: 'json',
          contentType: 'application/json; charset=utf-8',
          processData: false,
          crossDomain: true
        };
        if (this.token != null) {
          ajaxArgs.beforeSend = function(xhr) {
            return xhr.setRequestHeader('Authorization', "SimpleAuth " + _this.token);
          };
        }
        return $.ajax($.extend(ajaxArgs, args));
      }
    };
  });

}).call(this);
