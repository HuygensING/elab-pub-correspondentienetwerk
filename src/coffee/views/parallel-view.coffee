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

		initialize: (@options) ->
			super

			@panels = []

			if 'id' of @options
				@model = new Entry id: @options.id
				@model.fetch success: => @render()

			@addPanel()
			@render()

		closeParallelView: ->	@remove()
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
				p.$el.css
					left: (pos * p.$el.outerWidth()) + 'px'

		panel: (idx) ->
			@panels[idx]

		appendPanel: (p) ->
			@$('.panel-container').append p.el
			p.$el.css height: '200px'
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