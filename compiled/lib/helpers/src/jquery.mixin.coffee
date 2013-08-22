define (require) ->
	$ = require 'jquery'

	do (jQuery) ->

		jQuery.expr[":"].contains = $.expr.createPseudo (arg) ->
			(elem) -> $(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0

		jQuery.fn.scrollTo = (newPos, args) ->
			defaults = 
				start: ->
				complete: ->
				duration: 500

			options = $.extend defaults, args

			options.start() if options.start

			scrollTop = @scrollTop()
			top = @offset().top
			extraOffset = 60

			newPos = newPos + scrollTop - top - extraOffset

			if newPos isnt scrollTop
				@animate {scrollTop: newPos}, options.duration, options.complete
			else
				options.complete()

		jQuery.fn.highlight = (delay) ->
			delay = delay || 3000

			@addClass 'highlight'

			setTimeout (=>
				@removeClass 'highlight'
			), delay