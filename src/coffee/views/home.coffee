define (require) ->
	Backbone = require 'backbone'
	
	config = require 'config'

	SearchView = require 'views/search'
	EntryView = require 'views/entry'
	AnnotationsView = require 'views/annotations'

	events = require 'events'

	EntryCollection = require 'collections/entries'
	Entry = require 'models/entry'

	class Home extends Backbone.View
		template: require 'text!html/home.html'
		initialize: ->
			# Cache entries
			@entries = new EntryCollection
			@searchView = new SearchView

			# only instantiate once entry model is loaded
			@entryView = {}

			@annotationsView = new AnnotationsView

			@currentView = @searchView

			@render()

		showEntryLayer: (id, layer) ->
			@showEntry id: id, layer: layer
		showEntryHighlightAnnotation: (id, layer, annotation) ->
			@showEntry id: id, layerSlug: layer, annotation: annotation
		showEntry: (options) ->
			# In case just ID is passed in
			options = id: options if _.isString options

			attachEntryView = =>
				_.extend options, model: @entries.get options.id
				@entryView = new EntryView options
				@$('.entry-view').html @entryView.el
				@switchView @entryView

			if @entries.get options.id # it's already cached
				attachEntryView()
			else
				entry = new Entry id: options.id
				entry.fetch().done =>
					@entries.add entry
					attachEntryView()

		showSearch: ->
			@switchView @searchView

		showAnnotationsIndex: ->
			@switchView @annotationsView

		switchView: (newView) ->
			if newView isnt @currentView
				@currentView.$el.fadeOut 75, ->
					newView.$el.fadeIn 150
			@currentView = newView

		render: ->
			@template = _.template @template
			@$el.html @template()

			@$('.search-view').html @searchView.$el
			@$('.entry-view').html @entryView?.$el
			@$('.annotations-view').html @annotationsView.$el

			@