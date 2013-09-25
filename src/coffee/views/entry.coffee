define (require) ->

	configData = require 'models/configdata'
	config = require 'config'

	BaseView = require 'views/base'
	TextView = require 'views/text'
	ParallelView = require 'views/parallel-view'

	Entry = require 'models/entry'

	class Home extends BaseView
		baseTemplate: require 'text!html/entry/base.html'
		headerTemplate: require 'text!html/entry/header.html'
		metadataTemplate: require 'text!html/entry/metadata.html'
		contentsTemplate: require 'text!html/entry/contents.html'
		# annotationsTemplate: require 'text!html/entry/annotations.html'

		className: 'entry'

		events:
			'click .versions li': 'changeTextVersion'
			'click .more button': 'toggleMoreMetadata'
			'click .parallel button': 'showParallelView'
			'click .thumbnail': 'showThumbnailParallelView'
			'click a.print': 'printEntry'

		setActiveTextVersion: (version) ->
			li = @$(".versions li[data-toggle=#{version}]")
			li.addClass('active').siblings().removeClass('active')

		changeTextVersion: (e) ->
			@currentTextVersion = $(e.currentTarget).data 'toggle'
			@setActiveTextVersion @currentTextVersion
			@textView.setView @currentTextVersion

		toggleMoreMetadata: (e) ->
			@$('.metadata').toggleClass 'more' # fields
			$(e.currentTarget).toggleClass 'more' # button

		showParallelView: ->
			if not @pv
				@pv = new ParallelView model: @model
				@$('.header').after @pv.el
			else
				@pv.show()

			@pv

		showThumbnailParallelView: (e) ->
			target = $(e.currentTarget)
			page = target.data 'page'

			@pv = @showParallelView()
			@pv.clearPanels()
			@pv.addPanel().setVersion 'Facsimile', page	
			@pv.addPanel().setVersion @currentTextVersion
			@pv.renderPanels()

		printEntry: (e) ->
			e.preventDefault()
			window.print()

		initialize: ->
			super

			@baseTemplate = _.template @baseTemplate
			@headerTemplate = _.template @headerTemplate
			@metadataTemplate = _.template @metadataTemplate
			@contentsTemplate = _.template @contentsTemplate

			if 'id' of @options
				console.log "new Entry #{@options.id}"
				@model = new Entry id: @options.id
				@model.fetch success: => @render()

			@options.mode = 'normal' unless @options.mode

			@currentTextVersion = @options.version || config.defaultTextVersion
			@numMetadataEntrys = @options.numMetadataEntrys || 4

			@didScroll = false
			@$el.click -> @didScroll = true

			doCheck = =>
				# console.log @$el, @didScroll
				if @didScroll
					didScroll = false
					@positionTextView()
			setInterval doCheck, 250

			# @$('body').scroll (e) =>
			# 	if 
			# 		@$('.text-view').addClass 'fixed'
			# 	else if not @$('.text-view').hasClass 'fixed'
			# 		@fixTextView()

			@render()

		positionTextView: ->
			console.log  "YELLOW"
			@$('.text-view').css 'background-color': 'yellow'

		renderMetadata: ->
			metadata = @model.get('metadata') || []
			@$('.metadata').html @metadataTemplate
				metadata: metadata

			@

		renderHeader: ->
			@$('.header').html @headerTemplate
				config: config
				entry: @model.attributes

			prev = configData.findPrev @options.id
			if prev
				@$('.prev').attr href: config.entryURL prev
			next = configData.findNext @options.id
			if next
				@$('.next').attr href: config.entryURL next

			@$('.prev').toggleClass 'hide', not prev
			@$('.next').toggleClass 'hide', not next

		renderContents: ->
			@$('.contents').html @contentsTemplate
				entry: @model.attributes
				config: config

			@textView = new TextView
				model: @model
				version: @currentTextVersion
				el: @$('.contents .text-view')

		renderLineNumbering: ->
			lineNumbers = $('<div>').addClass 'line-numbers'
			lines = ""
			for n in [1..200]
				lines += "#{n}<br>"
			lineNumbers.html lines
			@$('.text .line-numbers').remove()
			@$('.text').append lineNumbers

		renderEntry: ->
			@renderHeader()
			@renderMetadata()
			@renderContents()
			@renderLineNumbering()

			@setActiveTextVersion @currentTextVersion

		render: ->
			@$el.html @baseTemplate()
			@renderEntry()

			@