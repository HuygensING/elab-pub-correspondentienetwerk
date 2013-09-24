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

		events:
			'click .versions li': 'changeTextVersion'
			'click .more button': 'toggleMoreMetadata'
			'click .parallel button': 'showParallelView'

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

		showParallelView: (e) ->
			if not @pv
				@pv = new ParallelView model: @model
				@$('.header').after @pv.el
			else
				@pv.show()
			

		initialize: ->
			super

			@baseTemplate = _.template @baseTemplate
			@headerTemplate = _.template @headerTemplate
			@metadataTemplate = _.template @metadataTemplate
			@contentsTemplate = _.template @contentsTemplate

			if 'id' of @options
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

		renderEntry: ->
			@renderHeader()
			@renderMetadata()
			@renderContents()

			@setActiveTextVersion @currentTextVersion

		render: ->
			@$el.html @baseTemplate()
			@renderEntry()

			@