#
#  HTML5 Shiv v3.6.2pre | @afarkas @jdalton @jon_neal @rem | MIT/GPL2 Licensed
#
define 'html5shiv', ->
	((a, b) ->
	  l = (a, b) ->
	    c = a.createElement("p")
	    d = a.getElementsByTagName("head")[0] or a.documentElement
	    c.innerHTML = "x<style>" + b + "</style>"
	    d.insertBefore(c.lastChild, d.firstChild)
	  m = ->
	    a = s.elements
	    (if "string" is typeof a then a.split(" ") else a)
	  n = (a) ->
	    b = j[a[h]]
	    b or (b = {}
	    i++
	    a[h] = i
	    j[i] = b
	    )
	    b
	  o = (a, c, d) ->
	    return c.createElement(a)  if c or (c = b)
	    k

	    d or (d = n(c))
	    g = undefined
	    g = (if d.cache[a] then d.cache[a].cloneNode() else (if f.test(a) then (d.cache[a] = d.createElem(a)).cloneNode() else d.createElem(a)))
	    (if g.canHaveChildren and not e.test(a) then d.frag.appendChild(g) else g)
	  p = (a, c) ->
	    return a.createDocumentFragment()  if a or (a = b)
	    k

	    c = c or n(a)
	    d = c.frag.cloneNode()
	    e = 0
	    f = m()
	    g = f.length

	    while g > e
	      d.createElement f[e]
	      e++
	    d
	  q = (a, b) ->
	    b.cache or (b.cache = {}
	    b.createElem = a.createElement
	    b.createFrag = a.createDocumentFragment
	    b.frag = b.createFrag()
	    )
	    a.createElement = (c) ->
	      (if s.shivMethods then o(c, a, b) else b.createElem(c))

	    a.createDocumentFragment = Function("h,f", "return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&(" + m().join().replace(/\w+/g, (a) ->
	      b.createElem(a)
	      b.frag.createElement(a)
	      "c(\"" + a + "\")"
	    ) + ");return n}")(s, b.frag)
	  r = (a) ->
	    a or (a = b)
	    c = n(a)
	    not s.shivCSS or g or c.hasCSS or (c.hasCSS = !!l(a, "article,aside,figcaption,figure,footer,header,hgroup,nav,section{display:block}mark{background:#FF0;color:#000}"))
	    k or q(a, c)
	    a
	  g = undefined
	  k = undefined
	  c = "3.6.2pre"
	  d = a.html5 or {}
	  e = /^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i
	  f = /^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i
	  h = "_html5shiv"
	  i = 0
	  j = {}
	  (->
	    try
	      a = b.createElement("a")
	      a.innerHTML = "<xyz></xyz>"
	      g = "hidden" of a
	      k = 1 is a.childNodes.length or (->
	        b.createElement "a"
	        a = b.createDocumentFragment()
	        a.cloneNode is undefined or a.createDocumentFragment is undefined or a.createElement is undefined
	      )()
	    catch c
	      g = not 0
	      k = not 0
	  )()
	  s =
	    elements: d.elements or "abbr article aside audio bdi canvas data datalist details figcaption figure footer header hgroup main mark meter nav output progress section summary time video"
	    version: c
	    shivCSS: d.shivCSS isnt not 1
	    supportsUnknownElements: k
	    shivMethods: d.shivMethods isnt not 1
	    type: "default"
	    shivDocument: r
	    createElement: o
	    createDocumentFragment: p

	  a.html5 = s
	  r(b)
	)(this, document)