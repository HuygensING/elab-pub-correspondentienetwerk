define (require) ->
	Backbone = require 'backbone'
	viewManager = require 'managers/view'
	Pubsub = require 'managers/pubsub'
	currentUser = require 'models/currentUser'

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
			'parallel/:id': 'parallelView'
			'item/:id': 'item'

		home: ->
			viewManager.show Views.Search

		parallelView: (id) ->
			viewManager.show Views.ParallelView, id: id

		item: (id) ->
			viewManager.show Views.Item, id: id