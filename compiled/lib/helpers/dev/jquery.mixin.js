(function() {
  define(function(require) {
    var $;
    $ = require('jquery');
    return (function(jQuery) {
      jQuery.expr[":"].contains = $.expr.createPseudo(function(arg) {
        return function(elem) {
          return $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
        };
      });
      jQuery.fn.scrollTo = function(newPos, args) {
        var defaults, extraOffset, options, scrollTop, top;
        defaults = {
          start: function() {},
          complete: function() {},
          duration: 500
        };
        options = $.extend(defaults, args);
        if (options.start) {
          options.start();
        }
        scrollTop = this.scrollTop();
        top = this.offset().top;
        extraOffset = 60;
        newPos = newPos + scrollTop - top - extraOffset;
        if (newPos !== scrollTop) {
          return this.animate({
            scrollTop: newPos
          }, options.duration, options.complete);
        } else {
          return options.complete();
        }
      };
      return jQuery.fn.highlight = function(delay) {
        var _this = this;
        delay = delay || 3000;
        this.addClass('highlight');
        return setTimeout((function() {
          return _this.removeClass('highlight');
        }), delay);
      };
    })(jQuery);
  });

}).call(this);
