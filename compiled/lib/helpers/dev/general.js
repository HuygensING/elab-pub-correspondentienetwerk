(function() {
  define(function(require) {
    var $;
    $ = require('jquery');
    return {
      /*
      	Generates an ID that starts with a letter
      	
      	Example: "aBc12D34"
      
      	param Number length of the id
      	return String
      */

      generateID: function(length) {
        var chars, text;
        length = (length != null) && length > 0 ? length - 1 : 7;
        chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        text = chars.charAt(Math.floor(Math.random() * 52));
        while (length--) {
          text += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return text;
      },
      /*
      	Deepcopies arrays and object literals
      	
      	return Array or object
      */

      deepCopy: function(object) {
        var newEmpty;
        newEmpty = Array.isArray(object) ? [] : {};
        return $.extend(true, newEmpty, object);
      },
      /*
      	Starts a timer which resets when it is called again.
      	
      	Example: with a scroll event, when a user stops scrolling, the timer ends.
      		Without the reset, the timer would fire dozens of times.
      	
      	return Function
      */

      timeoutWithReset: (function() {
        var timer;
        timer = 0;
        return function(ms, cb) {
          clearTimeout(timer);
          return timer = setTimeout(cb, ms);
        };
      })(),
      /*
      	Highlight text between two nodes. 
      
      	Creates a span.hilite between two given nodes, surrounding the contents of the nodes
      */

      highlightBetweenNodes: function(args) {
        var className, el, endNode, range, startNode, tagName;
        startNode = args.startNode, endNode = args.endNode, className = args.className, tagName = args.tagName;
        if (className == null) {
          className = 'hilite';
        }
        if (tagName == null) {
          tagName = 'span';
        }
        range = document.createRange();
        range.setStartAfter(startNode);
        range.setEndBefore(endNode);
        el = document.createElement(tagName);
        el.className = className;
        el.appendChild(range.extractContents());
        return range.insertNode(el);
      }
    };
  });

}).call(this);
