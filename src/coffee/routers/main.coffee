Backbone = require 'backbone'
$ = require 'jquery'
_ = require 'underscore'
us = require 'underscore.string'

events = require '../events'

config = require '../models/config'

persons = require '../collections/persons'

Views =
	FS: require 'hibb-faceted-search'
	# Search: require '../views/search'
	Entry: require '../views/entry'
	Annotations: require '../views/annotations'
	Person: require '../views/person'
	PersonPopup: require '../views/person-popup'

letterResultTpl = require '../../jade/letter-faceted-search-result.jade'
personResultTpl = require '../../jade/person-faceted-search-result.jade'
replaceNamesWithLinks = require '../replace-names-with-links'

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
		'person-search': 'showPersonSearch'
		'person/:id': 'person'
		'annotations': 'annotationsIndex'
		'entry/:id/:layer/:annotation': 'entry'
		'entry/:id/:layer': 'entry'
		'entry/:id': 'entry'

	initialize: ->
		@currentView = null

		@once 'route', (route, params) =>
			if route isnt 'showSearch'
				@showSearch false

		@on 'route', (route, params) =>
			$('header a.active').removeClass 'active'
			a = $("header a[name=\"#{route}\"]")
			a.addClass 'active' if a.length > 0

	entry: do ->
		entryView = null

		->
			if _.isObject arguments[0]
				options = arguments[0]
			else if _.isString arguments[0]
				options = 
					entryId: arguments[0]
					layerSlug: arguments[1]
					annotation: arguments[2]

			if entryView? and options? and options.hasOwnProperty('entryId')
				entryView.navBar.navigateEntry options.entryId
			
			unless entryView?
				entryView = new Views.Entry options
				$('#main').append entryView.$el

			switchView entryView

	person: (id) ->
		personView = new Views.Person id: id
		personView.cache = false
		personView.el.style.display = "block"

		$('#main > .person-detail').html personView.$el

		switchView personView

	showSearch: do ->
		searchView = null

		(show=true) ->
			unless searchView?
				popup = null
				timer = null
				facetNames = ['metadata_afzender_s', 'metadata_ontvanger_s', 'mv_metadata_correspondents']

				getSelector = (facetName) ->
					"div[data-name=\"#{facetName}\"] .body .container ul li"

				removeHover = (selector) ->
					searchView.$(selector).off "mouseenter", "mouseleave"
					
					if timer?
						clearTimeout timer 

					if popup?
						popup.destroy()

				addHover = (facetName) ->
					selector = getSelector(facetName)
					removeHover selector

					handleEnter = (ev) ->
						timer = setTimeout (->
							target = $(ev.currentTarget)
							target.addClass 'with-popup'

							label = target.find('label').html()

							splitters = ['/', '-->']
							for splitter in splitters
								if label.indexOf(splitter) isnt -1
									labels = label.split(splitter)

							unless labels
								labels = [label]

							ids = []
							for label in labels
								# console.log persons.filter((p) -> p.get('koppelnaam').toLowerCase().indexOf('maria') > -1).map((p) -> p.get('koppelnaam'))
								person = persons.findWhere koppelnaam: label
								ids.push person.id

							popup = new Views.PersonPopup
								ids: ids
								position: target.offset()
								height: target.height()

						), 500

					handleLeave = (ev) ->
						if popup?
							$(ev.currentTarget).removeClass 'with-popup'
							popup.destroy()

						clearTimeout timer

					searchView.$(selector).hover handleEnter, handleLeave

				searchView = new Views.FS
					el: $('.faceted-search-placeholder.letter')
					baseUrl: config.get('baseURL')
					searchPath: config.get('searchPath')
					textLayers: config.get('textLayers')
					entryTermSingular: config.get('entryTermSingular')
					entryTermPlural: config.get('entryTermPlural')
					entryMetadataFields: config.get('entryMetadataFields')
					levels: config.get('levels')
					results: true
					queryOptions:
						resultFields: ['metadata_datum']
					showMetadata: true
					termSingular: "letter"
					termPlural: "letters"
					templates:
						result: letterResultTpl
					templateData:
						result:
							replace: replaceNamesWithLinks
							createLink: (name) ->
								"#{name} <i class=\"fa fa-external-link\" data-name=\"#{name}\" />"

				@listenToOnce searchView, "change:results", ->
					config.set "isLetterFacetedSearchLoaded", true
	
				@listenTo searchView, "change:results", ->
					for facetName in facetNames
						searchView.facets.views[facetName].optionsView.renderAll()
						addHover facetName

				@listenTo searchView, "results:render:finished", ->
					searchView.$(".results ul.page li i.fa").on 'click', (ev) =>
						ev.stopPropagation()
						person = persons.findWhere koppelnaam: ev.currentTarget.getAttribute('data-name')
						Backbone.history.navigate "person/#{person.id}", trigger: true

				@listenTo searchView, 'result:click', (data) ->
					Backbone.history.navigate "entry/#{data.id}", trigger: true

				@listenTo Backbone, "search-person", (koppelnaam) ->
					Backbone.history.navigate "search", trigger: true
					searchView.searchValue "mv_metadata_correspondents", koppelnaam

				# searchView.$el.hide()
				searchView.search()

			if show
				searchView.$el.show()
				switchView searchView

	showPersonSearch: do ->
		personSearchView = null

		->
			unless personSearchView?
				personSearchView = new Views.FS
					el: $('.faceted-search-placeholder.person')
					baseUrl: config.get('timbuctooBase')
					searchPath: "search/cnwpersons"
					textLayers: config.get('textLayers')
					entryTermSingular: config.get('entryTermSingular')
					entryTermPlural: config.get('entryTermPlural')
					entryMetadataFields: config.get('personMetadataFields')
					levels: config.get('personLevels')
					levelDisplayNames:
						dynamic_k_birthDate: "Geboortejaar"
						dynamic_k_deathDate: "Sterfjaar"
						dynamic_sort_name: "Achternaam"
					results: true
					showMetadata: false
					termSingular: "person"
					termPlural: "persons"
					templates:
						result: personResultTpl
					requestOptions:
						headers:
							VRE_ID: "CNW"
					facetOrder: [
						"dynamic_s_koppelnaam"
						"dynamic_s_altname"
						"dynamic_s_gender"
						"dynamic_s_networkdomain"
						"dynamic_s_characteristic"
						"dynamic_s_subdomain"
						"dynamic_s_domain"
					]
					parsers:
						dynamic_s_gender: (facetData) ->
							geslachten =
								MALE: "Man"
								FEMALE: "Vrouw"
								UNKNOWN: "Onbekend"

							for option in facetData.options
								option.displayName = geslachten[option.name]

							facetData


				@listenTo personSearchView, 'result:click', (data) ->
					Backbone.history.navigate "person/#{data._id}", trigger: true

				personSearchView.$el.show()
				personSearchView.search()

			switchView personSearchView

	annotationsIndex: do ->
		annotationsView = null

		->
			unless annotationsView?
				annotationsView = new Views.Annotations
				$('.annotations-view').html annotationsView.$el
				
			switchView annotationsView

	# ### Methods
	###
	# Because we want to sent the terms straight to the entry view (and not via the url),
	# we have to manually change the url, trigger the route and call @entry.
	###
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