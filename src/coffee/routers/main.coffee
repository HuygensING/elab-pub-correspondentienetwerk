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
			'entry/:id/parallel': 'entryParallelView'
			'entry/:id/:version': 'entryVersionView'
			'entry/:id': 'entry'

		home: ->
			viewManager.show Views.Search

		entryParallelView: (id) ->
			viewManager.show Views.ParallelView,
				id: id
				mode: 'parallel'

		entryVersionView: (id, version) ->
			viewManager.show Views.Entry,
				id: id
				version: version

		entry: (id) ->
			console.log "Entry #{id}"
			viewManager.show Views.Entry, id: id