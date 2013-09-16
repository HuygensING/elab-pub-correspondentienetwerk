define (require) ->

	configData = require 'models/configdata'
	config = require 'config'

	BaseView = require 'views/base'
	TextView = require 'views/text'
	ParallelView = require 'views/parallel-view'

	Item = require 'models/item'

	class Home extends BaseView
		baseTemplate: require 'text!html/item/base.html'
		headerTemplate: require 'text!html/item/header.html'
		metadataTemplate: require 'text!html/item/metadata.html'
		contentsTemplate: require 'text!html/item/contents.html'
		# annotationsTemplate: require 'text!html/item/annotations.html'

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
				@model = new Item id: @options.id
				@model.fetch success: => @render()

			@options.mode = 'normal' unless @options.mode

			@currentTextVersion = @options.version || config.defaultTextVersion
			@numMetadataItems = @options.numMetadataItems || 4

			@$('body').scroll (e) =>
				if 
					@$('.text-view').addClass 'fixed'
				else if not @$('.text-view').hasClass 'fixed'
					@fixTextView()

			@render()

		renderMetadata: ->
			metadata = @model.get('metadata') || []
			@$('.metadata').html @metadataTemplate
				metadata: metadata

			@

		renderHeader: ->
			@$('.header').html @headerTemplate
				item: @model.attributes

			prev = configData.findPrev @options.id
			if prev
				@$('.prev').attr href: config.itemURL prev
			next = configData.findNext @options.id
			if next
				@$('.next').attr href: config.itemURL next

			@$('.prev').toggleClass 'hide', not prev
			@$('.next').toggleClass 'hide', not next

		renderContents: ->
			@$('.contents').html @contentsTemplate
				item: @model.attributes
				config: config

			@textView = new TextView
				model: @model
				version: @currentTextVersion
				el: @$('.contents .text-view')

		renderItem: ->
			@renderHeader()
			@renderMetadata()
			@renderContents()

			@setActiveTextVersion @currentTextVersion

		render: ->
			@$el.html @baseTemplate()
			@renderItem()

			@