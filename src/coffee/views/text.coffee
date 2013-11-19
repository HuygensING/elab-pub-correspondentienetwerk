define (require) ->
	configData = require 'models/configdata'
	config = require 'config'
	BaseView = require 'views/base'

	Helpers = require 'helpers/general'

	jqv = require 'jquery-visible'

	class TextView extends Backbone.View
		template: require 'text!html/text.html'
		annotationsTemplate: require 'text!html/annotations.html'

		events:
			'click .annotations li': 'scrollToAnnotation'

		initialize: (@options) ->
			@template = _.template @template
			@annotationsTemplate = _.template @annotationsTemplate
			@currentTextLayer = @options.layer || config.defaultTextLayer

			if document.createRange
				@hl = Helpers.highlighter
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
			@hl.on
				startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
				endNode: @$(".text sup[data-marker=end][data-id=#{markerID}]")[0]
			console.log "Highliting", markerID

		scrollToAnnotation: (e) ->
			target = $(e.currentTarget)
			annID = target.attr 'data-id'
			annotation = @$(".text span[data-marker=begin][data-id=#{annID}]")

			if annotation.visible()
				console.log "Annotation is visible", annID
			else
				console.log "Not visible"

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