define (require) ->
	Views = 
		Base: require 'views/base'

	Templates =
		Header: require 'text!html/ui/header.html'

	class Header extends Views.Base

		tagName: 'header'

		initialize: ->
			super

			@render()

		render: ->
			rtpl = _.template Templates.Header
			@$el.html rtpl

			@