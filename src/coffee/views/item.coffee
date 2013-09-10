define (require) ->

	configData = require 'models/configdata'
	config = require 'config'
	BaseView = require 'views/base'
	TextView = require 'views/text'

	Item = require 'models/item'
	Templates =
		Home: require 'text!html/item.html'
		Metadata: require 'text!html/metadata.html'
		Annotations: require 'text!html/annotations.html'

	class Home extends BaseView
		events:
			'click .versions li': 'changeTextVersion'
			'click .more button': 'toggleMoreMetadata'

		changeTextVersion: (e) ->
			target = $(e.currentTarget)
			target.addClass('active').siblings().removeClass('active')
			@currentTextVersion = target.data 'toggle'

			@textView.setView @currentTextVersion

		toggleMoreMetadata: (e) ->
			more = not $(e.currentTarget).hasClass 'more'
			$(e.currentTarget).toggleClass 'more'

			if more
				@numMetadataItems = @model.get('metadata')?.length
			else
				@numMetadataItems = 4
			@renderMetadata()

		initialize: ->
			super

			if 'id' of @options
				@model = new Item id: @options.id
				@model.fetch success: => @render()

			@currentTextVersion = 'Translation'
			@numMetadataItems = 4

			@render()

		renderMetadata: ->
			tmpl = _.template Templates.Metadata
			metadata = @model.get('metadata') || []
			@$('.metadata .span8').html tmpl metadata: metadata[0..@numMetadataItems-1]
			@

		renderNavigation: ->
			prev = configData.findPrev @options.id
			if prev
				@$('.prev').attr href: config.itemURL prev
			next = configData.findNext @options.id
			if next
				@$('.next').attr href: config.itemURL next

			@$('.prev').toggleClass 'hide', not prev
			@$('.next').toggleClass 'hide', not next

		render: ->
			rtpl = _.template Templates.Home
			@$el.html rtpl item: {}

			item = @model.attributes
			if 'name' of item
				@$el.html rtpl item: item

			@renderNavigation()
			@renderMetadata()

			@textView = new TextView
				model: @model
				el: @$('.text-view')

			@