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
		Item: require 'views/item'
		ParallelView: require 'views/parallel-view'

	class MainRouter extends Backbone.Router
		initialize: ->
			_.extend @, Pubsub

			@on 'route', @show, @

		'routes':
			'': 'home'
			'item/:id': 'item'
			'item/:id/parallel': 'itemParallelView'
			'item/:id/:version': 'itemVersionView'

		home: ->
			viewManager.show Views.Search

		itemParallelView: (id) ->
			viewManager.show Views.ParallelView,
				id: id
				mode: 'parallel'

		itemVersionView: (id, version) ->
			viewManager.show Views.Item,
				id: id
				version: version

		item: (id) ->
			viewManager.show Views.Item, id: id