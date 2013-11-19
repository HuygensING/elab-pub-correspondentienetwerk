define (require) ->
	Backbone = require 'backbone'
	viewManager = require 'managers/view'

	events = require 'events'

	# Set page title
	configData = require 'models/configdata'
	configData.on 'change', =>
		# Use document.title to ensure IE compatibility
		document.title = configData.get 'title'

	class MainRouter extends Backbone.Router
		routes:
			'': 'showSearch'
			'annotations/': 'showAnnotationsIndex'
			'entry/:id/parallel': 'showEntryParallelView'
			'entry/:id/:layer': 'showEntryLayer'
			'entry/:id/:layer/:annotation': 'showEntryHighlightAnnotation'
			'entry/:id': 'showEntry'

		initialize: (options) ->
			super

			{@controller, @root} = options
			@processRoutes()

		start: ->
			Backbone.history.start
				root: @root
				pushState: true 

		processRoutes: ->
			for route, methodName of @routes when methodName of @controller
				method = @controller[methodName].bind @controller
				@route route, methodName, method