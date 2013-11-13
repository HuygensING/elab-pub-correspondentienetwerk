define (require) ->

	configData = require 'models/configdata'
	config = require 'config'

	events = require 'events'

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

		toggleMoreMetadata: ->
			@$('.metadata').toggleClass 'more' # fields
			@$('.metadata button').toggleClass 'more' # button
			configData.set showMetaData: @$('.metadata').hasClass 'more'
			console.log configData.attributes

		showParallelView: ->
			@pv = new ParallelView model: @model
			@$('.parallel-view-container').empty().html @pv.el
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

		initialize: (@options) ->
			super

			@baseTemplate = _.template @baseTemplate
			@headerTemplate = _.template @headerTemplate
			@metadataTemplate = _.template @metadataTemplate
			@contentsTemplate = _.template @contentsTemplate

			if 'id' of @options
				@model = new Entry id: @options.id
				@model.fetch success: => @render()

			events.on 'change:view:entry', (options) =>
				@model = new Entry id: options.id
				@model.fetch().done => @render()

			@options.mode = 'normal' unless @options.mode

			@currentTextVersion = @options.version || config.defaultTextVersion
			@numMetadataEntrys = @options.numMetadataEntrys || 4

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

			@render() if @model?.id

		positionTextView: ->
			@$('.text-view').css 'background-color': 'yellow'

		renderMetadata: ->
			metadata = @model.get('metadata') || []
			@$('.metadata').html @metadataTemplate
				metadata: metadata

			@toggleMoreMetadata() if configData.get 'showMetaData'

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

			console.log "Next,pref", next, prev,  configData.findPrev(@model.id)

			@$('.prev-entry').toggleClass 'hide', not prev
			@$('.next-entry').toggleClass 'hide', not next

		renderContents: ->
			@$('.contents').html @contentsTemplate
				entry: @model.attributes
				config: config

			@textView = new TextView
				model: @model
				version: @currentTextVersion
				el: @$('.contents .text-view')

		renderEntry: ->
			@renderHeader()
			@renderMetadata()
			@renderContents()

			@setActiveTextVersion @currentTextVersion

		render: ->
			@$el.html @baseTemplate()
			@renderEntry()

			@