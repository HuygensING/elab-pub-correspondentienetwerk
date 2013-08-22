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
	###
	highlightBetweenNodes: (args)->
		{startNode, endNode, className, tagName} = args

		className = 'hilite' if not className?
		tagName = 'span' if not tagName?

		range = document.createRange()

		range.setStartAfter startNode
		range.setEndBefore endNode

		el = document.createElement tagName
		el.className = className

		el.appendChild range.extractContents()
		range.insertNode el