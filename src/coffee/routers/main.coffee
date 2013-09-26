define (require) ->
	Backbone = require 'backbone'
	viewManager = require 'managers/view'
	Pubsub = require 'managers/pubsub'
	currentUser = require 'models/currentUser'

	# Set page title
	configData = require 'models/configdata'
	configData.on 'change', =>
		$('title').text configData.get 'title'

	Views =
		Home: require 'views/home'
		Search: require 'views/search'
		Entry: require 'views/entry'
		ParallelView: require 'views/parallel-view'

	class MainRouter extends Backbone.Router
		initialize: ->
			_.extend @, Pubsub

			@on 'route', @show, @

		'routes':
			'': 'home'
			"#{config.basePath}entry/:id/parallel": 'entryParallelView'
			"#{config.basePath}entry/:id/:version": 'entryVersionView'
			"#{config.basePath}entry/:id": 'entry'

		home: ->
			console.log "Showuing home"
			viewManager.show Views.Search

		entryParallelView: (id) ->
			viewManager.show Views.ParallelView,
				id: id
				mode: 'parallel'

		entryVersionView: (id, version) ->
			console.log "Showing version #{version} for #{id}"
			viewManager.show Views.Entry,
				id: id
				version: version

		entry: (id) ->
			console.log "Entry #{id}"
			viewManager.show Views.Entry, id: id