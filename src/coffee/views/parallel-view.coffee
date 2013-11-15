define (require) ->
	BaseView = require 'views/base'
	PanelView = require 'views/panel'

	Entry = require 'models/entry'

	configData = require 'models/configdata'

	Templates =
		ParallelView: require 'text!html/parallel-view.html'

	class ParallelView extends BaseView
		className: 'parallel-view'
		events:
			'click .add': 'addPanelEvent'
			'click .panel .close': 'closePanel'
			'click button.close': 'closeParallelView'

		initialize: (@options) ->
			super

			@textLayers = _.flatten [ 'Facsimile', configData.get 'textLayers' ]
			console.log "text layers", configData.attr

			@panels = []

			if 'id' of @options
				@model = new Entry id: @options.id
				@model.fetch success: => @render()

			@render()

		closeParallelView: ->
			@$('.parallel-controls').css position: 'relative'
			@$('.parallel-overlay').animate {
				left: '-100%', opacity: 0
			}, 250, => @remove()

		show: -> @$el.show()
		hide: -> @$el.hide()

		closePanel: (e) ->
			pNumber = $(e.currentTarget).closest('.panel-frame').index()
			[panel] = @panels.splice pNumber, 1
			panel.remove()
			@repositionPanels()

		addPanelEvent: (e) ->
			@addPanel()

			last = @panels.length - 1
			lastPanel = @panels[last]
			@appendPanel lastPanel
			
			lastPanel.$('.panel').addClass 'new'
			removeNew = -> lastPanel.$('.panel').removeClass 'new'
			setTimeout removeNew, 1500

			po = @$('.parallel-overlay')
			po.animate
				scrollLeft: (po[0].scrollWidth - po[0].clientWidth + 1200) + 'px'

		addPanel: (panel) ->
			panel ?= new PanelView model: @model
			@panels.push panel
			panel

		availableLayers: ->
			usedLayers = _.map @panels, (p) -> p.textLayer
			availableLayers = _.difference @textLayers, usedLayers

		emptyPanel: ->
			console.log "Called mpty panel"
			panel = new PanelView
				model: @model
				versions: @availableLayers()

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

		renderPanels: ->
			@$('.panel-container').empty()
			console.log "Panels", @panels.length
			@addPanel @emptyPanel()
			console.log "Panels", @panels.length
			for p, pos in @panels
				@appendPanel p
				@positionPanel p, pos
			

		render: ->
			tmpl = _.template Templates.ParallelView
			@$el.html tmpl entry: @model?.attributes
			@$('.title').text @model.get 'name'

			@renderPanels()

			@