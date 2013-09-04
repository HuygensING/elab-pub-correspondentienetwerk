define (require) ->
	Item = require 'models/item'

	PanelTextView = require 'views/panel-text-view'

	Templates =
		Panel: require 'text!html/panel.html'

	jqu = require 'jquery-ui/jquery-ui'
	console.log jqu

	class PanelView extends Backbone.View
		className: 'panel'
		events:
			'click .selection li': 'selectText'

		initialize: ->
			if 'id' of @options and not @model
				@model = new Item id: @options.id
				@model.fetch success: => @render()
			else if @model
				@render()

		selectText: (e) ->
			target = $(e.currentTarget)
			textVersion = target.data 'toggle'

			@subView = new PanelTextView
				model: @model
				version: textVersion
			@$('.view').html @subView.el

		positionSelectionTab: ->
			ml = @$('.selection').outerWidth() / 2
			mt = @$('.selection').outerHeight()
			@$('.selection').css
				left: '50%'
				'margin-left': "-#{ml}px"
				'margin-top': "-#{mt}px"

		render: ->
			tmpl = _.template Templates.Panel
			@$el.html tmpl item: @model?.attributes

			@positionSelectionTab()
			
			# @$el.draggable()

			@