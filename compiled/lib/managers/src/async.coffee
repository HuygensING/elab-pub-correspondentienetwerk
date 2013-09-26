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
			@callbacksCalled[name] = data
			@ready() if _.every @callbacksCalled, (called) -> 
				called isnt false

		ready: -> @trigger 'ready', @callbacksCalled