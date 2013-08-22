define (require) ->
	Backbone = require 'backbone'

	subscribe: (ev, cb) ->
		this.listenTo Backbone, ev, cb

	publish: ->
		# FIXME [UNSUPPORTED]: arguments can't be array like object in IE < 10
		Backbone.trigger.apply Backbone, arguments