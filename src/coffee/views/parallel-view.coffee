define (require) ->
	BaseView = require 'views/base'
	PanelView = require 'views/panel'

	Item = require 'models/item'

	Templates =
		ParallelView: require 'text!html/parallel-view.html'

	class Home extends BaseView
		className: 'parallel-view'
		events:
			'click .add': 'addPanel'

		initialize: ->
			super

			@panels = []

			if 'id' of @options
				@model = new Item id: @options.id
				@model.fetch success: => @render()

			@render()

		addPanel: (e) ->
			panel = new PanelView id: @options.id
			@$('.panel-container').append panel.el
			@panels.push panel
			panel.render()

			@

		render: ->
			tmpl = _.template Templates.ParallelView
			@$el.html tmpl item: @model?.attributes

			@addPanel().addPanel().addPanel()

			@