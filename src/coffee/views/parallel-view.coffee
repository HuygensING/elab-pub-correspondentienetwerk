define (require) ->
	BaseView = require 'views/base'
	PanelView = require 'views/panel'

	Entry = require 'models/entry'

	Templates =
		ParallelView: require 'text!html/parallel-view.html'

	class ParallelView extends BaseView
		className: 'parallel-view'
		events:
			'click .add': 'addPanelEvent'
			'click .panel .close': 'closePanel'
			'click button.close': 'closeParallelView'

		initialize: ->
			super

			@panels = []

			if 'id' of @options
				@model = new Entry id: @options.id
				@model.fetch success: => @render()

			@addPanel()
			@render()

		closeParallelView: ->	@hide()
		show: -> @$el.show()
		hide: -> @$el.hide()

		closePanel: (e) ->
			pNumber = $(e.currentTarget).closest('.panel').index()
			[panel] = @panels.splice pNumber, 1
			panel.remove()
			@repositionPanels()

		addPanelEvent: (e) ->
			@addPanel()

			last = @panels.length - 1
			lastPanel = @panels[last]
			@appendPanel lastPanel
			
			lastPanel.$el.addClass 'new'
			removeNew = -> lastPanel.$el.removeClass 'new'
			setTimeout removeNew, 1300

			$('html, body').animate
				scrollLeft: @panels[last].$el.offset().left

		addPanel: ->
			panel = new PanelView model: @model
			@panels.push panel
			panel

		positionPanel: (p, pos=0) ->
			p.$el.css
				top: 0
				# assuming they're all the same size:
				left: (pos * p.$el.outerWidth()) + 'px'

		repositionPanels: ->
			for p, pos in @panels
				console.log "Pois", pos
				p.$el.css
					left: (pos * p.$el.outerWidth()) + 'px'

		panel: (idx) ->
			console.log("PANELS", @panels)
			@panels[idx]

		appendPanel: (p) ->
			@$('.panel-container').append p.el
			@positionPanel p, @panels.length - 1
			p.positionSelectionTab()

		clearPanels: ->
			@panels = []
			@renderPanels()

		renderPanels: ->
			@$('.panel-container').empty()
			for p, pos in @panels
				@appendPanel p
				@positionPanel p, pos

		render: ->
			tmpl = _.template Templates.ParallelView
			@$el.html tmpl entry: @model?.attributes

			@renderPanels()

			@