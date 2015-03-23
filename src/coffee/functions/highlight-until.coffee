module.exports = (startNode, endNode, options={}) ->
	options.highlightClass ?= 'highlight'
	options.tagName ?= 'span'

	on: ->
		range = document.createRange()
		range.setStartAfter startNode
		range.setEndBefore endNode

		filter = (node) => 
			r = document.createRange()
			r.selectNode(node)

			start = r.compareBoundaryPoints(Range.START_TO_START, range)
			end = r.compareBoundaryPoints(Range.END_TO_START, range)

			if start is -1 or end is 1 then NodeFilter.FILTER_SKIP else	NodeFilter.FILTER_ACCEPT

		filter.acceptNode = filter
		
		treewalker = document.createTreeWalker range.commonAncestorContainer, NodeFilter.SHOW_TEXT, filter, false
		
		while treewalker.nextNode()
			range2 = new Range()
			range2.selectNode treewalker.currentNode

			newNode = document.createElement options.tagName
			newNode.className = options.highlightClass

			range2.surroundContents newNode
			
		@

	off: ->
		for el in document.querySelectorAll('.' + options.highlightClass)
			# Move the text out of the span.highlight
			el.parentElement.insertBefore(el.firstChild, el)

			# Remove the span.highlight
			el.parentElement.removeChild(el)