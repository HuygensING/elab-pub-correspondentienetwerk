define (require) ->
	BaseView = require 'views/base'
	config = require 'config'

	rangy = require 'rangy/rangy-cssclassapplier'
	rangy.init()

	jqv = require 'jquery-visible'

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
			'click .annotations li': 'scrollToAnnotation'

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

		highlightAnnotation: (markerID) ->
			# Delay highlighting for a bit until page is fully rendered
			# and everything's attached to DOM. Highlighter will error
			# out otherwise.
			highlight = => @hl.on
				startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
				endNode: @$(".text sup[data-marker=end][data-id=#{markerID}]")[0]
			_.delay highlight, 300 

		scrollToAnnotation: (e) ->
			target = $(e.currentTarget)
			annID = target.attr 'data-id'
			annotation = @$(".text span[data-marker=begin][data-id=#{annID}]")

			if annotation.visible()
				# console.log "Annotation is visible", annID
			else
				# console.log "Not visible"

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
					@hl.on
						startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
						endNode: @$(".text sup[data-marker=end][data-id=#{markerID}]")[0]
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