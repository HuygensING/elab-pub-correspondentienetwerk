define (require) ->
	Backbone = require 'backbone'
	_ = require 'underscore'

	Pubsub = require 'managers/pubsub'

	class History

		history: []

		constructor: ->
			_.extend @, Backbone.Events
			_.extend @, Pubsub

		update: ->
			@history.push window.location.pathname
			sessionStorage.setItem 'history', JSON.stringify(@history)

		clear: ->
			sessionStorage.removeItem 'history'

		last: ->
			@history[@history.length-1]

	new History()