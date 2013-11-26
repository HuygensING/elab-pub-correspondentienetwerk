define (require) ->
	BaseView = require 'views/base'
	PanelView = require 'views/panel'
	Entry = require 'models/entry'

	config = require 'config'

	Templates =
		ParallelView: require 'text!html/parallel-view.html'

	KEYCODE_ESCAPE = 27

	class ParallelView extends BaseView
		className: 'parallel-view'
		events:
			'click .add': 'scrollToEnd'
			'click .panel .close': 'closePanel'
			'click button.close': 'closeParallelView'
			'keydown *': 'ifEscapeClose'

		initialize: (@options={}) ->
			super

			$(document).keyup (e) => @ifEscapeClose(e)

			@textLayers = _.flatten [ 'Facsimile', config.get 'textLayers' ]

			@panels = []

			preLoad = @options.panels || config.get 'parallelPanels'
			if preLoad
				for opts in preLoad
					_.extend opts, model: @model
					@addPanel new PanelView opts

			@render()

		ifEscapeClose: (e) ->
			if e.keyCode is KEYCODE_ESCAPE
				@closeParallelView()

		closeParallelView: ->
			@$('.parallel-controls').css position: 'relative'
			@$('.parallel-overlay').animate {
				left: '-100%', opacity: 0
			}, 250, => @remove()

		show: ->
			@$el.show()
			@$('.parallel-controls').css position: 'relative'
			@$('.parallel-overlay').css(left: '100%', opacity: '0').animate {
				left: '0%', opacity: '1' }, 150, => @$('.parallel-controls').css position: 'fixed'
		
		hide: ->
			@$el.hide()

		closePanel: (e) ->
			pNumber = $(e.currentTarget).closest('.panel-frame').index()
			[panel] = @panels.splice pNumber, 1
			panel.remove()
			@repositionPanels()

			# update available layer list
			if _.last(@panels).selectedLayer()
				@renderPanels()
				@renderAddButton()
				@scrollToEnd()
			else
				_.last(@panels).setAvailableLayers(@availableLayers()).render()

			@renderAddButton() # re-enable

		scrollToEnd: ->
			po = @$('.parallel-overlay')
			po.animate
				scrollLeft: (po[0].scrollWidth - po[0].clientWidth + 1200) + 'px'

		layerSelected: ->
			@renderAddButton()
			@renderPanels()
			@scrollToEnd()

		addPanel: (panel) ->
			panel ?= new PanelView model: @model
			@panels.push panel
			@listenTo panel, 'layer-selected', @layerSelected	
			panel

		availableLayers: ->
			usedLayers = _.map @panels, (p) -> p.selectedLayer()
			availableLayers = _.difference @textLayers, usedLayers

		emptyPanel: ->
			panel = new PanelView
				model: @model
				layers: @availableLayers()

			panel

		positionPanel: (p, pos=0) ->
			p.$el.css
				top: 0
				# assuming they're all the same size:
				left: (pos * p.$el.outerWidth()) + 'px'

		repositionPanels: ->
			for p, pos in @panels
				p.$el.css
					left: (pos * p.$el.outerWidth()) + 'px'

		panel: (idx) ->
			@panels[idx]

		appendPanel: (p) ->
			@$('.panel-container').append p.el
			p.$el.css height: '200px'
			@positionPanel p, @panels.length - 1

		clearPanels: ->
			@panels = []
			@renderPanels()

		renderAddButton: ->
			noLayers = @availableLayers().length is 0
			addButton = @$('.parallel-controls button.add')
			if noLayers
				addButton.attr 'disabled', 'disabled'
			else
				addButton.removeAttr 'disabled'

		renderPanels: ->
			@$('.panel-container').empty()
			@addPanel @emptyPanel() if @availableLayers().length
			for p, pos in @panels
				@appendPanel p
				@positionPanel p, pos

		render: ->
			tmpl = _.template Templates.ParallelView
			@$el.html tmpl entry: @model?.attributes
			@$('.title').text @model.get 'name'

			@renderPanels()

			@