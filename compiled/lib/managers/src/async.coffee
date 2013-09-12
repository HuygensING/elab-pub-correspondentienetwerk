define (require) ->
	_ = require 'underscore'

	class Async
		constructor: (names = []) ->
			_.extend(@, Backbone.Events)

			@callbacksCalled = {}
			
			@register names

		register: (names) -> 
			for name in names
				@callbacksCalled[name] = false
				
		called: (name, data = true) ->
			console.log 'called', name, data
			@callbacksCalled[name] = data
			@ready() if _.every @callbacksCalled, (called) -> 
				console.log called
				called isnt false

		ready: -> 
			console.log 'ready!!'
			@trigger 'ready', @callbacksCalled