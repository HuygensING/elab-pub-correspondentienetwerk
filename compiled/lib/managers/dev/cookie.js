(function() {
  define(function(require) {
    return {
      get: function(name) {
        var c, nameEQ, _i, _len, _ref;
        nameEQ = name + "=";
        _ref = document.cookie.split(';');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          c = _ref[_i];
          while (c.charAt(0) === ' ') {
            c = c.substring(1, c.length);
          }
          if (c.indexOf(nameEQ) === 0) {
            return c.substring(nameEQ.length, c.length);
          }
        }
      },
      set: function(name, value, days) {
        var date, expires;
        if (days) {
          date = new Date();
          date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
          expires = "expires=" + date.toGMTString();
        } else {
          expires = "";
        }
        return document.cookie = "" + name + "=" + value + "; " + expires + "; path=/";
      },
      remove: function(name) {
        return this.set(name, "", -1);
      }
    };
  });

}).call(this);
