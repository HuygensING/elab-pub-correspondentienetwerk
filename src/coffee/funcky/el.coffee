module.exports =
	el: (el) ->
		# Native alternative to $.closest
		# See http://stackoverflow.com/questions/15329167/closest-ancestor-matching-selector-using-native-dom
		closest: (selector) ->
			matchesSelector = el.matches or el.webkitMatchesSelector or el.mozMatchesSelector or el.msMatchesSelector

			while (el)
				if (matchesSelector.bind(el)(selector)) then return el else	el = el.parentNode

		###
		Native alternative to jQuery's $.offset()

		http://www.quirksmode.org/js/findpos.html
		###
		position: (parent=document.body) ->
			left = 0
			top = 0
			loopEl = el

			while loopEl? and loopEl isnt parent
				# Not every parent is an offsetParent. So in the case the user has passed a non offsetParent as the parent,
				# we check if the loop has passed the parent (by checking if the offsetParent has a descendant which is the parent).
				break if @hasDescendant parent

				left += loopEl.offsetLeft
				top += loopEl.offsetTop

				loopEl = loopEl.offsetParent

			left: left
			top: top

		boundingBox: ->
			box = @position()
			box.width = el.clientWidth
			box.height = el.clientHeight
			box.right = box.left + box.width
			box.bottom = box.top + box.height

			box

		###
		Is child el a descendant of parent el?

		http://stackoverflow.com/questions/2234979/how-to-check-in-javascript-if-one-element-is-a-child-of-another
		###
		hasDescendant: (child) ->
			node = child.parentNode

			while node?
				return true if node is el
				node = node.parentNode

			false

		insertAfter: (referenceElement) -> referenceElement.parentNode.insertBefore el, referenceElement.nextSibling

		hasScrollBar: (el) ->
			hasScrollBarX(el) or hasScrollBarY(el)

		hasScrollBarX: (el) ->
			el.scrollWidth > el.clientWidth

		hasScrollBarY: (el) ->
			el.scrollHeight > el.clientHeight

		# http://stackoverflow.com/questions/123999/how-to-tell-if-a-dom-element-is-visible-in-the-current-viewport/7557433#7557433
		inViewport: (parent) ->
			win = parent ? window
			doc = parent ? document.documentElement

			rect = el.getBoundingClientRect()

			rect.top >= 0 &&
				rect.left >= 0 &&
					rect.bottom <= (win.innerHeight || doc.clientHeight) &&
						rect.right <= (win.innerWidth || doc.clientWidth)