(function() {
  var __hasProp = {}.hasOwnProperty;

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
      
      	Example usage:
      	hl = Fn.highlighter
      		className: 'highlight' # optional
      		tagName: 'div' # optional
      
      	supEnter = (ev) -> hl.on
      		startNode: el.querySelector(#someid) # required
      		endNode: ev.currentTarget # required
      	supLeave = -> hl.off()
      	$(sup).hover supEnter, supLeave
      */

      highlighter: function(args) {
        var className, el, tagName;
        if (args == null) {
          args = {};
        }
        className = args.className, tagName = args.tagName;
        if (className == null) {
          className = 'hilite';
        }
        if (tagName == null) {
          tagName = 'span';
        }
        el = null;
        return {
          on: function(args) {
            var endNode, range, startNode;
            startNode = args.startNode, endNode = args.endNode;
            range = document.createRange();
            range.setStartAfter(startNode);
            range.setEndBefore(endNode);
            el = document.createElement(tagName);
            el.className = className;
            el.appendChild(range.extractContents());
            return range.insertNode(el);
          },
          off: function() {
            return $(el).replaceWith(function() {
              return $(this).contents();
            });
          }
        };
      },
      /*
      	Native alternative to jQuery's $.offset()
      
      	http://www.quirksmode.org/js/findpos.html
      */

      position: function(el, parent) {
        var left, top;
        left = 0;
        top = 0;
        while (el !== parent) {
          left += el.offsetLeft;
          top += el.offsetTop;
          el = el.offsetParent;
        }
        return {
          left: left,
          top: top
        };
      },
      boundingBox: function(el) {
        var box;
        box = $(el).offset();
        box.width = el.clientWidth;
        box.height = el.clientHeight;
        box.right = box.left + box.width;
        box.bottom = box.top + box.height;
        return box;
      },
      /*
      	Is child el a descendant of parent el?
      
      	http://stackoverflow.com/questions/2234979/how-to-check-in-javascript-if-one-element-is-a-child-of-another
      */

      isDescendant: function(parent, child) {
        var node;
        node = child.parentNode;
        while (node != null) {
          if (node === parent) {
            return true;
          }
          node = node.parentNode;
        }
        return false;
      },
      /*
      	Removes an element found by indexOf from an array
      */

      removeFromArray: function(arr, item) {
        var index;
        index = arr.indexOf(item);
        return arr.splice(index, 1);
      },
      /* Escape a regular expression*/

      escapeRegExp: function(str) {
        return str.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
      },
      /*
      	Flattens an object
      
      	songs:
      		mary:
      			had:
      				little: 'lamb'
      
      	becomes
      
      	songs:
      		mary.had.little: 'lamb'
      
      	Taken from: http://thedersen.com/projects/backbone-validation
      */

      flattenObject: function(obj, into, prefix) {
        var k, v;
        if (into == null) {
          into = {};
        }
        if (prefix == null) {
          prefix = '';
        }
        for (k in obj) {
          if (!__hasProp.call(obj, k)) continue;
          v = obj[k];
          if (_.isObject(v) && !_.isArray(v) && !_.isFunction(v)) {
            this.flattenObject(v, into, prefix + k + '.');
          } else {
            into[prefix + k] = v;
          }
        }
        return into;
      },
      compareJSON: function(current, changed) {
        var attr, changes, value;
        changes = {};
        for (attr in current) {
          if (!__hasProp.call(current, attr)) continue;
          value = current[attr];
          if (!changed.hasOwnProperty(attr)) {
            changes[attr] = 'removed';
          }
        }
        for (attr in changed) {
          if (!__hasProp.call(changed, attr)) continue;
          value = changed[attr];
          if (current.hasOwnProperty(attr)) {
            if (_.isArray(value) || this.isObjectLiteral(value)) {
              if (!_.isEqual(current[attr], changed[attr])) {
                changes[attr] = changed[attr];
              }
            } else {
              if (current[attr] !== changed[attr]) {
                changes[attr] = changed[attr];
              }
            }
          } else {
            changes[attr] = 'added';
          }
        }
        return changes;
      },
      isObjectLiteral: function(obj) {
        var ObjProto;
        if ((obj == null) || typeof obj !== "object") {
          return false;
        }
        ObjProto = obj;
        while (Object.getPrototypeOf(ObjProto = Object.getPrototypeOf(ObjProto)) !== null) {
          0;
        }
        return Object.getPrototypeOf(obj) === ObjProto;
      }
    };
  });

}).call(this);
