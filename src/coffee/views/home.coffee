define (require) ->
	BaseView = require 'views/base'
	configData = require 'models/configdata'

	class Home extends BaseView
		template: require 'text!html/home.html'
		initialize: ->
			super
			@render()

		render: ->
			@template = _.template @template
			@$el.html @template()

			@$('h1').text configData.get 'title'

			@