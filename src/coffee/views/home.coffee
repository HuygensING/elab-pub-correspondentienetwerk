define (require) ->

	BaseView = require 'views/base'

	Templates =
		Home: require 'text!html/home.html'

	class Home extends BaseView

		initialize: ->
			super

			@render()

		render: ->
			rtpl = _.template Templates.Home
			@$el.html rtpl

			@