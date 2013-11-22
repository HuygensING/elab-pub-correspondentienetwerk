define (require) ->
	config = require 'config'
	Entry = require 'models/entry'

	TextView = require 'views/text'
	FacsimileView = require 'views/facsimile'

	# jq = require 'jquery-ui/jquery-ui'

	class PanelView extends Backbone.View
		className: 'panel-frame'
		template: require 'text!html/panel.html'
		events:
			'click .select-layer li': 'selectLayer'

		initialize: (@options) ->
			@template = _.template @template

			@textLayer = @options?.textLayer
			@layers = @options.layers

			if 'id' of @options and not @model
				@model = new Entry id: @options.id
				@model.fetch success: => @render()
			else if @model
				@render()

		selectLayer: (e) ->
			target = $(e.currentTarget)
			layer  = target.data 'toggle'

			@setLayer layer
			@trigger 'layer-selected', layer

			@$('.panel').addClass 'new'
			removeNew = -> @$('.panel').removeClass 'new'
			setTimeout removeNew, 1000

		layerIsFacsimile: -> @textLayer is 'Facsimile'

		# Page is only relevant if layer is 'Facsimile'
		setLayer: (layer, page=null) ->
			@textLayer = layer
			@page = page if @layerIsFacsimile()
			@renderContent()

		setAvailableLayers: (@layers=[]) -> @ # no-op (but assign @layers)

		selectedLayer: -> @textLayer

		renderCurrentSelection: ->
			@$('.selection .current span').text @textLayer

		renderContent: ->
			if @layerIsFacsimile()
				@subView = new FacsimileView
					model: @model, page: @page
			else if @textLayer
				@subView = new TextView
					model: @model
					layer: @textLayer
			@$('.view').html @subView?.el
			@$('.layer').text @textLayer


		render: ->
			@$el.html @template
				entry: @model?.attributes
				layers: @layers
				layer: @textLayer

			@$el.toggleClass 'select', not @textLayer?

			@renderCurrentSelection()
			@renderContent()
			@$el.addClass config.panelSize

			@