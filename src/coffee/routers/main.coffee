define (require) ->
	Backbone = require 'backbone'
	viewManager = require 'managers/view'

	events = require 'events'

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
			@on 'route', @show, @
			@on 'route', =>
				events.trigger 'change:view', arguments

		'routes':
			'': 'home'
			"entry/:id/parallel": 'entryParallelView'
			"entry/:id/:version": 'entryVersionView'
			"entry/:id": 'entry'

		home: ->
			events.trigger 'change:view:search'
			# events.trigger 'change:view:home', arguments
			# viewManager.main = $('#main')
			# viewManager.show Views.Search

		entryParallelView: (id) ->
			events.trigger 'change:view:entry',
				id: id
				mode: 'parallel'
			# viewManager.show Views.ParallelView,
			# 	id: id
			# 	mode: 'parallel'

		entryVersionView: (id, version) ->
			# viewManager.show Views.Entry,
			events.trigger 'change:view:entry',
				id: id
				version: version

		entry: (id) ->
			console.log "showing entry?", id
			events.trigger 'change:view:entry', id: id
			# viewManager.show Views.Entry, id: id