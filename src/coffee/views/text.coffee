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
			@currentTextVersion = @options.version || config.defaultTextVersion

			@highlighter = new Helpers.highlighter

			@render()

		setView: (version) ->
			@currentTextVersion = version
			@renderContent()

		scrollToAnnotation: (e) ->
			target = $(e.currentTarget)
			annID = target.attr 'data-id'
			annotation = @$(".text span[data-marker=begin][data-id=#{annID}]")

			console.log jqv
			if annotation.visible()
				console.log "Annotation is visible", annID
			else
				console.log "Not visible"

		renderAnnotations: ->
			annotations = {}
			for a in @model.annotations(@currentTextVersion) || []
				annotations[a.n] = a

			orderedAnnotations = (annotations[id] for id in @$('.text sup').map -> $(@).data 'id')	
			@$('.annotations').html @annotationsTemplate
				annotations: orderedAnnotations


			if document.createRange	
				hl = Helpers.highlighter
					className: 'highlight' # optional
					tagName: 'div' # optional

				supEnter = (ev) =>
					el = ev.currentTarget
					markerID = $(el).data 'id'
					@$(".annotations li[data-id=#{markerID}]").addClass 'highlight'
					hl.on
						startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
						endNode: ev.currentTarget # required
				supLeave = (ev) =>
					markerID = $(ev.currentTarget).data 'id'
					@$(".annotations li[data-id=#{markerID}]").removeClass 'highlight'
					hl.off()
				@$('.text sup[data-marker]').hover supEnter, supLeave

				liEnter = (ev) =>
					el = ev.currentTarget
					markerID = $(el).data 'id'
					hl.on
						startNode: @$(".text span[data-marker=begin][data-id=#{markerID}]")[0]
						endNode: @$(".text sup[data-marker=end][data-id=#{markerID}]")[0]
				liLeave = -> hl.off()
				@$('.annotations li').hover liEnter, liLeave
			else # no document.createRange (IE8)
				# TODO: alternative?

			@

		renderLineNumbering: ->
			lineNumbers = $('<div>').addClass 'line-numbers'
			lines = ""
			for n in [1..1000] # TODO: hard-coded, but maybe better to compute?
				lines += "#{n}<br>"
			lineNumbers.html lines
			@$('.text .line-numbers').remove()
			@$('.text').append lineNumbers
			lineNumbers.css height: @$('.text').outerHeight()

		renderContent: ->
			text = @model.text @currentTextVersion
			@$('.text').html text
			@renderAnnotations()
			@renderLineNumbering()

			@

		render: ->
			@$el.html @template()
			@renderContent()