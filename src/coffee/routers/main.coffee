Backbone = require 'backbone'
$ = require 'jquery'
_ = require 'underscore'
us = require 'underscore.string'

events = require '../events'

config = require '../models/config'

Views =
	Search: require 'elaborate-modules/modules/views/faceted-search-results'
	# Search: require '../views/search'
	Entry: require '../views/entry'
	Annotations: require '../views/annotations'

switchView = do ->
	currentView = null

	(newView) ->
		showNewView = ->
			newView.$el.fadeIn 150, ->
				newView.activate() if newView.activate?
				newView.$el.show() if newView.cache? and newView.cache

				currentView = newView
				currentView.cache ?= true

		if currentView?
			currentView.deactivate() if currentView.deactivate?

			currentView.$el.fadeOut 75, ->
				if currentView.cache then currentView.$el.hide() else currentView.destroy()

				showNewView()
		else
			showNewView()

class MainRouter extends Backbone.Router

	routes:
		'': 'entry'
		'search': 'showSearch'
		'annotations': 'annotationsIndex'
		'entry/:id/:layer/:annotation': 'entry'
		'entry/:id/:layer': 'entry'
		'entry/:id': 'entry'

	initialize: ->
		@currentView = null

		@on 'route', (route, params) =>
			$('header a.active').removeClass 'active'
			a = $("header a[name=\"#{route}\"]")
			a.addClass 'active' if a.length > 0

	entry: ->
		if _.isObject arguments[0]
			options = arguments[0]
		else if _.isString arguments[0]
			options = 
				entryId: arguments[0]
				layerSlug: arguments[1]
				annotation: arguments[2]

		entry = new Views.Entry options
		entry.cache = false
		$('#main > .entries').append entry.$el

		switchView entry

	showSearch: do ->
		searchView = null

		->
			unless searchView?
				searchView = new Views.Search
					searchUrl: config.get('baseUrl') + config.get('searchPath')
					textLayers: config.get('textLayers')
					entryTermSingular: config.get('entryTermSingular')
					entryTermPlural: config.get('entryTermPlural')
					entryMetadataFields: config.get('entryMetadataFields')
					levels: config.get('levels')
				$('.search-view').html searchView.$el

				@listenTo searchView, 'change:results', (responseModel) -> config.set facetedSearchResponse: responseModel
				@listenTo searchView, 'navigate:entry', @navigateEntry

			switchView searchView

	annotationsIndex: do ->
		annotationsView = null

		->
			unless annotationsView?
				annotationsView = new Views.Annotations
				$('.annotations-view').html annotationsView.$el
				
			switchView annotationsView

	# ### Methods

	# Because we want to sent the terms straight to the entry view (and not via the url),
	# we have to manually change the url, trigger the route and call @entry.
	navigateEntry: (id, terms, textLayer) ->
		url = "entry/#{id}"

		options =
			entryId: id
			terms: terms

		if textLayer
			splitLayer = textLayer.split(' ')
			if splitLayer[splitLayer.length - 1] is 'annotations'
				splitLayer.pop()
				textLayer = splitLayer.join(' ')
				options.highlightAnnotations = true

			options.layerSlug = us.slugify(textLayer)
		
			url = "#{url}/#{options.layerSlug}"

		@navigate url

		# We have to manually trigger route, because we navigate without {trigger: true} and call @entry manually.
		# The route listener is used to update the header.main menu.
		@trigger 'route', 'entry'
		
		@entry options

module.exports = new MainRouter()