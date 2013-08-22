define (require) ->
	Backbone = require 'backbone'
	_ = require 'underscore'

	Pubsub = require 'managers/pubsub'

	class Token

		token: null

		constructor: ->
			_.extend @, Backbone.Events
			_.extend @, Pubsub

		set: (token) ->
			@token = token
			sessionStorage.setItem 'huygens_token', token

		get: ->	
			@token = sessionStorage.getItem 'huygens_token' if not @token?

			if not @token?
				@publish 'unauthorized'
				return false

			@token

		clear: ->
			sessionStorage.removeItem 'huygens_token'

	new Token()