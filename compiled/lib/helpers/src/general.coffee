define (require) ->
	$ = require 'jquery'

	###
	Generates an ID that starts with a letter
	
	Example: "aBc12D34"

	param Number length of the id
	return String
	###
	generateID: (length) ->
		length = if length? and length > 0 then (length-1) else 7

		chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
		text = chars.charAt(Math.floor(Math.random() * 52)) # Start with a letter

		while length-- # Countdown is more lightweight than for-loop
			text += chars.charAt(Math.floor(Math.random() * chars.length))

		text

	###
	Deepcopies arrays and object literals
	
	return Array or object
	###
	deepCopy: (object) ->
		newEmpty = if Array.isArray(object) then [] else {}
		$.extend true, newEmpty, object

	###
	Starts a timer which resets when it is called again.
	
	Example: with a scroll event, when a user stops scrolling, the timer ends.
	Without the reset, the timer would fire dozens of times.
	Can also be handy to avoid double clicks.

	Example usage:
	div.addEventListener 'scroll', (ev) ->
		Fn.timeoutWithReset 200, -> console.log('finished!')
	
	return Function
	###
	timeoutWithReset: do ->
		timer = 0
		(ms, cb) ->
			clearTimeout timer
			timer = setTimeout cb, ms

	###
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

	###
	highlighter: (args={}) ->
		{className, tagName} = args

		className = 'hilite' if not className?
		tagName = 'span' if not tagName?

		el = null # Create reference to the element doing the highlighting
		
		on: (args) ->
			{startNode, endNode} = args

			range = document.createRange()
			range.setStartAfter startNode
			range.setEndBefore endNode

			el = document.createElement tagName
			el.className = className
			el.appendChild range.extractContents()
			
			range.insertNode el

		off: ->
			$(el).replaceWith -> $(@).contents()


	###
	Native alternative to jQuery's $.offset()

	http://www.quirksmode.org/js/findpos.html
	###
	position: (el, parent) ->
		left = 0
		top = 0

		while el isnt parent
			left += el.offsetLeft
			top += el.offsetTop
			el = el.offsetParent

		left: left
		top: top

	boundingBox: (el) ->
		box = $(el).offset()
		box.width = el.clientWidth
		box.height = el.clientHeight
		box.right = box.left + box.width
		box.bottom = box.top + box.height

		box

	###
	Is child el a descendant of parent el?

	http://stackoverflow.com/questions/2234979/how-to-check-in-javascript-if-one-element-is-a-child-of-another
	###
	isDescendant: (parent, child) ->
		node = child.parentNode
		
		while node?
			return true if node is parent
			node = node.parentNode

		return false

	###
	Removes an item from an array
	###
	removeFromArray: (arr, item) ->
		index = arr.indexOf item
		arr.splice index, 1

	### Escape a regular expression ###
	escapeRegExp: (str) -> str.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

	###
	Flattens an object

	songs:
		mary:
			had:
				little: 'lamb'

	becomes

	songs:
		mary.had.little: 'lamb'

	Taken from: http://thedersen.com/projects/backbone-validation
	###
	flattenObject: (obj, into, prefix) ->
		into ?= {}
		prefix ?= ''

		for own k, v of obj
			if _.isObject(v) and not _.isArray(v) and not _.isFunction(v)
				@flattenObject v, into, prefix + k + '.'
			else
				into[prefix+k] = v

		into

	compareJSON: (current, changed) ->
		changes = {}

		for own attr, value of current
			changes[attr] = 'removed' unless changed.hasOwnProperty attr

		for own attr, value of changed
			if current.hasOwnProperty attr
				if _.isArray(value) or @isObjectLiteral(value)
					changes[attr] = changed[attr] unless _.isEqual current[attr], changed[attr]
				else
					changes[attr] = changed[attr] unless current[attr] is changed[attr]
			else
				changes[attr] = 'added'

		changes

	isObjectLiteral: (obj) ->
		return false if not obj? or typeof obj isnt "object"

		ObjProto = obj

		0 while Object.getPrototypeOf(ObjProto = Object.getPrototypeOf(ObjProto)) isnt null

		Object.getPrototypeOf(obj) is ObjProto

	getScrollPercentage: (el) ->
		scrolledTop = el.scrollTop
		totalTop = el.scrollHeight - el.clientHeight

		scrolledLeft = el.scrollLeft
		totalLeft = el.scrollWidth - el.clientWidth

		top: Math.floor (scrolledTop/totalTop) * 100
		left: Math.floor (scrolledLeft/totalLeft) * 100

	setScrollPercentage: (el, percentages) ->
		clientWidth = el.clientWidth
		scrollWidth = el.scrollWidth
		clientHeight = el.clientHeight
		scrollHeight = el.scrollHeight

		el.scrollTop = (scrollHeight - clientHeight) * percentages.top/100
		el.scrollLeft = (scrollWidth - clientWidth) * percentages.left/100

	checkCheckboxes: (selector, checked=true, baseEl=document) ->
		checkboxes = baseEl.querySelectorAll selector
		cb.checked = checked for cb in checkboxes