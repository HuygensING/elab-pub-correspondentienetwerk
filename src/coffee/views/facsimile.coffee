define (require) ->
	Backbone = require 'backbone'
	
	class Facsimile extends Backbone.View
		template: require 'text!html/facsimile-zoom.html'
		initialize: (@options) ->
			@template = _.template @template
			@size = @options.size || 'large'
			@page = @options.page || 0
			@render()

		render: ->
			@$el.html @template
				model: @model
				entry: @model.attributes
				page: @page
				size: @size
