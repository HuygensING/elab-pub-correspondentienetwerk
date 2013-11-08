(function() {
  define('html5shiv', function() {
    return (function(a, b) {
      var c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s;
      l = function(a, b) {
        var c, d;
        c = a.createElement("p");
        d = a.getElementsByTagName("head")[0] || a.documentElement;
        c.innerHTML = "x<style>" + b + "</style>";
        return d.insertBefore(c.lastChild, d.firstChild);
      };
      m = function() {
        a = s.elements;
        if ("string" === typeof a) {
          return a.split(" ");
        } else {
          return a;
        }
      };
      n = function(a) {
        b = j[a[h]];
        b || (b = {}, i++, a[h] = i, j[i] = b);
        return b;
      };
      o = function(a, c, d) {
        var g;
        if (c || (c = b)) {
          return c.createElement(a);
        }
        k;
        d || (d = n(c));
        g = void 0;
        g = (d.cache[a] ? d.cache[a].cloneNode() : (f.test(a) ? (d.cache[a] = d.createElem(a)).cloneNode() : d.createElem(a)));
        if (g.canHaveChildren && !e.test(a)) {
          return d.frag.appendChild(g);
        } else {
          return g;
        }
      };
      p = function(a, c) {
        var d, e, f, g;
        if (a || (a = b)) {
          return a.createDocumentFragment();
        }
        k;
        c = c || n(a);
        d = c.frag.cloneNode();
        e = 0;
        f = m();
        g = f.length;
        while (g > e) {
          d.createElement(f[e]);
          e++;
        }
        return d;
      };
      q = function(a, b) {
        b.cache || (b.cache = {}, b.createElem = a.createElement, b.createFrag = a.createDocumentFragment, b.frag = b.createFrag());
        a.createElement = function(c) {
          if (s.shivMethods) {
            return o(c, a, b);
          } else {
            return b.createElem(c);
          }
        };
        return a.createDocumentFragment = Function("h,f", "return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&(" + m().join().replace(/\w+/g, function(a) {
          b.createElem(a);
          b.frag.createElement(a);
          return "c(\"" + a + "\")";
        }) + ");return n}")(s, b.frag);
      };
      r = function(a) {
        var c;
        a || (a = b);
        c = n(a);
        !s.shivCSS || g || c.hasCSS || (c.hasCSS = !!l(a, "article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}"));
        k || q(a, c);
        return a;
      };
      g = void 0;
      k = void 0;
      c = "3.6.2pre";
      d = a.html5 || {};
      e = /^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i;
      f = /^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i;
      h = "_html5shiv";
      i = 0;
      j = {};
      (function() {
        try {
          a = b.createElement("a");
          a.innerHTML = "<xyz></xyz>";
          g = "hidden" in a;
          return k = 1 === a.childNodes.length || (function() {
            b.createElement("a");
            a = b.createDocumentFragment();
            return a.cloneNode === void 0 || a.createDocumentFragment === void 0 || a.createElement === void 0;
          })();
        } catch (_error) {
          c = _error;
          g = !0;
          return k = !0;
        }
      })();
      s = {
        elements: d.elements || "abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup main mark meter nav output progress section summary time video",
        version: c,
        shivCSS: d.shivCSS !== !1,
        supportsUnknownElements: k,
        shivMethods: d.shivMethods !== !1,
        type: "default",
        shivDocument: r,
        createElement: o,
        createDocumentFragment: p
      };
      a.html5 = s;
      return r(b);
    })(this, document);
  });

}).call(this);
