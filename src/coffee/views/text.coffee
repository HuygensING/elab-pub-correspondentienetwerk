define (require) ->
	Backbone = require 'backbone'
	config = require 'config'

	rangy = require 'rangy/rangy-cssclassapplier'
	rangy.init()

	require 'jquery.scrollTo'

	highlighter = rangy.createCssClassApplier 'highlight'

	class Highlighter
		on: (args) ->
			{startNode, endNode} = args
			
			@r = rangy.createRange()
			@r.setStartAfter startNode
			@r.setEndBefore endNode

			highlighter.applyToRange @r
		off: ->
			highlighter.undoToRange @r

	class TextView extends Backbone.View
		template: require 'text!html/text.html'
		annotationsTemplate: require 'text!html/annotations.html'

		events:
			'click .annotations li': 'clickAnnotation'

		initialize: (@options) ->
			@template = _.template @template
			@annotationsTemplate = _.template @annotationsTemplate
			@currentTextLayer = @options.layer || config.get 'textLayer' || config.defaultTextLayer

			if document.createRange
				@hl = new Highlighter
					className: 'highlight' # optional
					tagName: 'div' # optional
			else
				@hl = # Allow IE8 to fail gracefully
					on: ->
					off: ->

			@render()

		setView: (layer) ->
			@currentTextLayer = layer
			@renderContent()

		annotationNodes: (markerID) ->
			startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
			endNode: @$(".text sup[data-marker=end][data-id=#{markerID}]")[0]

		highlightAnnotation: (markerID) ->
			# Delay highlighting for a bit until page is fully rendered
			# and everything's attached to DOM. Highlighter will error
			# out otherwise.
			{startNode, endNode} = @annotationNodes markerID
			highlight = =>
				@hl.on
					startNode: startNode
					endNode: endNode
				@scrollToAnnotation startNode
			_.delay highlight, 300

		clickAnnotation: (e) ->
			target = $(e.currentTarget)
			annID = target.attr 'data-id'
			{startNode} = @annotationNodes annID
			@scrollToAnnotation startNode

		scrollToAnnotation: (annotation) ->
			$('body').scrollTo annotation,
				duration: 1000
				axis: 'y'
				offset:
					top: -100

		renderAnnotations: ->
			annotations = {}
			for a in @model.annotations(@currentTextLayer) || []
				annotations[a.n] = a

			orderedAnnotations = (annotations[id] for id in @$('.text sup').map -> $(@).data 'id')	
			@$('.annotations').html @annotationsTemplate
				annotations: orderedAnnotations

			if document.createRange	
				supEnter = (ev) =>
					el = ev.currentTarget
					markerID = $(el).data 'id'
					@$(".annotations li[data-id=#{markerID}]").addClass 'highlight'
					@hl.on
						startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
						endNode: ev.currentTarget # required
				supLeave = (ev) =>
					markerID = $(ev.currentTarget).data 'id'
					@$(".annotations li[data-id=#{markerID}]").removeClass 'highlight'
					@hl.off()
				@$('.text sup[data-marker]').hover supEnter, supLeave

				liEnter = (ev) =>
					el = ev.currentTarget
					markerID = $(el).data 'id'
					{startNode, endNode} = @annotationNodes markerID
					@hl.on
						startNode: startNode
						endNode: endNode
				liLeave = => @hl.off()
				@$('.annotations li').hover liEnter, liLeave
			else # no document.createRange (IE8)
				# TODO: alternative?

			@

		renderLineNumbering: ->
			@$('.line').each (n, line) =>
				$(line).prepend $('<div class="number"/>').text(n+1)

		renderContent: ->
			text = @model.text @currentTextLayer

			if text?.length
				@$('.text').html text
				@renderLineNumbering()
			else
				@$('.text').html "<p class=no-data>#{@currentTextLayer} text layer is empty</p>"
			@renderAnnotations()

			@

		render: ->
			@$el.html @template()
			@renderContent()