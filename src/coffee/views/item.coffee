define (require) ->

	BaseView = require 'views/base'

	Item = require 'models/item'
	Templates =
		Home: require 'text!html/item.html'

	class Home extends BaseView

		initialize: ->
			super

			if 'id' of @options
				@model = new Item id: @options.id
				@model.fetch success: => @render()

			@render()

		render: ->
			rtpl = _.template Templates.Home
			
			if @model.has 'name'
				console.log @model.attributes
				@$el.html rtpl item: @model.attributes
			else
				@$el.html rtpl item: {}


			@