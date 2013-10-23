define (require) ->
	Backbone = require 'backbone'
	events = {}
	_.extend events, Backbone.Events

	events