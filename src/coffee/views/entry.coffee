define (require) ->

	configData = require 'models/configdata'
	config = require 'config'

	events = require 'events'

	BaseView = require 'views/base'
	TextView = require 'views/text'
	ParallelView = require 'views/parallel-view'

	Entry = require 'models/entry'

	KEYCODE_ESCAPE = 27

	class Entry extends BaseView
		baseTemplate: require 'text!html/entry/base.html'
		headerTemplate: require 'text!html/entry/header.html'
		metadataTemplate: require 'text!html/entry/metadata.html'
		contentsTemplate: require 'text!html/entry/contents.html'

		className: 'entry'

		events:
			'click .layers li': 'changeTextLayer'
			'click .more button': 'toggleMoreMetadata'
			'click .parallel button': 'showParallelView'
			'click .thumbnail': 'showThumbnailParallelView'
			'click a.print': 'printEntry'

		initialize: (@options={}) ->
			super

			@baseTemplate = _.template @baseTemplate
			@headerTemplate = _.template @headerTemplate
			@metadataTemplate = _.template @metadataTemplate
			@contentsTemplate = _.template @contentsTemplate

			@currentTextLayer = if @options.layerSlug?
				configData.slugToLayer @options.layerSlug
			else if @options.layer?
				@options.layer
			else
				configData.get 'textLayer'

			console.log "Show args", @options

			$(document).keyup (e) => @ifEscapeClose e

			@didScroll = false
			@$el.click -> @didScroll = true
			doCheck = =>
				if @didScroll
					didScroll = false
					@positionTextView()
			# setInterval doCheck, 1000

			$('body, html').scroll (e) =>
				@didScroll = true

			# @$('body').scroll (e) =>
			# 	if 
			# 		@$('.text-view').addClass 'fixed'
			# 	else if not @$('.text-view').hasClass 'fixed'
			# 		@fixTextView()

			@render()

		setActiveTextLayer: (layer) ->
			li = @$(".layers li[data-toggle=#{layer}]")
			li.addClass('active').siblings().removeClass('active')

		changeTextLayer: (e) ->
			@currentTextLayer = $(e.currentTarget).data 'toggle'
			@setActiveTextLayer @currentTextLayer
			@textView.setView @currentTextLayer
			configData.set textLayer: @currentTextLayer

		toggleMoreMetadata: (e) ->
			show = not $(e.currentTarget).hasClass 'more'
			@showMoreMetaData show, yes # animate
		
		showMoreMetaData: (show, animate=no) ->
			if show
				@$('.metadata').addClass 'more' # fields
				@$('.metadata button').addClass 'more' # button
				@$('.metadata li').show()
			else
				@$('.metadata').removeClass 'more' # fields
				@$('.metadata button').removeClass 'more' # button
				@$('.metadata li').show().filter (idx) -> $(@).hide() if idx > 3

			configData.set showMetaData: show

		showParallelView: (opts={}) ->
			_.extend opts, model: @model
			@pv = new ParallelView opts
			@$('.parallel-view-container').empty().html @pv.el
			@pv.show()

			@pv

		showThumbnailParallelView: (e) ->
			target = $(e.currentTarget)
			page = target.data 'page'

			@pv = @showParallelView
				panels: [
					{ textLayer: 'Facsimile', page: page}
					{ textLayer: @currentTextLayer }
				]
			@pv.repositionPanels()

		printEntry: (e) ->
			e.preventDefault()
			window.print()

		close: -> # TODO: no-op, but in future: fadeOut?

		ifEscapeClose: (e) ->
			if e.keyCode is KEYCODE_ESCAPE
				@close()

		positionTextView: ->
			@$('.text-view').css 'background-color': 'yellow'

		renderMetadata: ->
			metadata = @model.get('metadata') || []
			@$('.metadata').html @metadataTemplate
				metadata: metadata

			if configData.get('showMetaData')?
				@showMoreMetaData configData.get('showMetaData')
			else
				@showMoreMetaData false

			@

		renderHeader: ->
			@$('.header').html @headerTemplate
				config: config
				entry: @model.attributes
				entries: configData

			prev = configData.findPrev @model.id
			if prev
				@$('.prev').attr href: config.entryURL prev
			next = configData.findNext @model.id
			if next
				@$('.next').attr href: config.entryURL next

			@$('.prev-entry').toggleClass 'hide', not prev
			@$('.next-entry').toggleClass 'hide', not next

			@renderResultsNavigation()

		renderResultsNavigation: ->
			ids = configData.get 'allResultIds'
			showResultsNav = ids?.length > 0 and ids.indexOf(String @model.id) isnt -1
			@$('.navigate-results').toggle showResultsNav

			if ids?.length
				id = @model.id
				prevId = ids[ids.indexOf(String id) - 1] ? null
				nextId = ids[ids.indexOf(String id) + 1] ? null

				# console.log prevId, nextId
				
				@$('.navigate-results .prev-result').toggle(prevId?).attr href: config.entryURL prevId
				@$('.navigate-results .next-result').toggle(nextId?).attr href: config.entryURL nextId
				@$('.navigate-results .idx').text ids.indexOf(String id) + 1
				@$('.navigate-results .total').text ids.length

		renderContents: ->
			@$('.contents').html @contentsTemplate
				entry: @model.attributes
				config: config
				configData: configData

			@textView = new TextView
				model: @model
				layer: @currentTextLayer
				el: @$('.contents .text-view')

			if @options.annotation?
				console.log "Highlighting #{@options.annotation}!"
				@textView.highlightAnnotation @options.annotation

		renderEntry: ->
			@renderHeader()
			@renderMetadata()
			@renderContents()

			@setActiveTextLayer @currentTextLayer

		render: ->
			@$el.html @baseTemplate()
			@renderEntry()

			@