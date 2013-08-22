(function() {
  define(function(require) {
    var $;
    $ = require('jquery');
    return {
      ucfirst: function(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
      },
      /*
      	Slugify a string
      */

      slugify: function(str) {
        var from, index, strlen, to;
        from = "àáäâèéëêìíïîòóöôùúüûñç·/_:;";
        to = "aaaaeeeeiiiioooouuuunc-----";
        str = str.trim().toLowerCase();
        strlen = str.length;
        while (strlen--) {
          index = from.indexOf(str[strlen]);
          if (index !== -1) {
            str = str.substr(0, strlen) + to[index] + str.substr(strlen + 1);
          }
        }
        return str.replace(/[^a-z0-9 -]/g, '').replace(/\s+|\-+/g, '-').replace(/^\-+|\-+$/g, '');
      },
      /*
      	Strips the tags from a string
      	
      	Example: "This is a <b>string</b>." => "This is a string."
      	
      	return String
      */

      stripTags: function(str) {
        return $('<span />').html(str).text();
      },
      /*
      	Removes non numbers from a string
      	
      	Example: "There are 12 monkeys." => "12"
      	
      	return String
      */

      onlyNumbers: function(str) {
        return str.replace(/[^\d.]/g, '');
      }
    };
  });

}).call(this);
