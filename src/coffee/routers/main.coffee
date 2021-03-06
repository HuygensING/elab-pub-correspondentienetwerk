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
			$('header li.menu-item.active').removeClass 'active'
			doIt = () =>
				$('#menu-item-14').addClass 'active' if route is 'showSearch'
				$('#menu-item-40').addClass 'active' if route is 'showPersonSearch'

			setTimeout doIt, 1000

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
				facetNames = [
					'metadata_afzender',
					'metadata_ontvanger',
					'mv_metadata_correspondents'
				]
				facetOrder = [
					"metadata_afzender",
					"metadata_ontvanger",
					"mv_metadata_correspondents",
					"metadata_plaats",
					"metadata_datum",
					"metadata_datum_range",
					"metadata_annotatie",
					"metadata_taal",
					"metadata_bijlage",
					"metadata_herkomst_transcriptie",
					"metadata_bewaarplaats",
					"metadata_collectie",
					"metadata_signatuur"
				]
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

							if label.indexOf('#') > -1
								label = label.substr(0, label.indexOf('#'))

							splitters = ['/', '--&gt;']
							for splitter in splitters
								if label.indexOf(splitter) isnt -1
									labels = label.split(splitter)

							unless labels
								labels = [label]

							ids = []
							for label in labels
								person = persons.findWhere koppelnaam: label
								if person.id?
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
					customQueryNames:
						metadata_datum_range: 'metadata_datum'
					searchPath: config.get('searchPath')
					textLayers: config.get('textLayers')
					entryTermSingular: config.get('entryTermSingular')
					entryTermPlural: config.get('entryTermPlural')
					entryMetadataFields: config.get('entryMetadataFields')
					facetOrder: facetOrder
					levels: config.get('levels')
					results: true
					rangeFacetAlwaysShowButton: true
					queryOptions:
						resultFields: config.get('levels')
					showMetadata: true
					labels:
						numFound: "Gevonden"
						filterOptions: "Vind..."
						sortAlphabetically: "Sorteer alfabetisch"
						sortNumerically: "Sorteer op aantal"
					termSingular: "brief"
					termPlural: "brieven"
					templates:
						result: letterResultTpl
					templateData:
						result:
							replace: replaceNamesWithLinks
							createLink: (name) ->
								"#{name} <i class=\"fa fa-external-link\" data-name=\"#{name}\" />"
					textSearchOptions:
						fuzzy: false
						caseSensitive: false

				@listenToOnce searchView, "change:results", ->
					config.set "isLetterFacetedSearchLoaded", true

				@listenTo searchView, "change:results", (data) ->
					config.set "facetedSearchResponse", data
					for facetName in facetNames
						searchView.facets.views[facetName].optionsView.renderAll()
						addHover facetName

				@listenTo searchView, "results:render:finished", ->
					$(".hibb-pagination .text").html("van")
					$(".hibb-pagination .prev").attr("title", "Vorige pagina")
					$(".hibb-pagination .prev10").attr("title", "Spring 10 pagina's terug")
					$(".hibb-pagination .next").attr("title", "Volgende pagina")
					$(".hibb-pagination .next10").attr("title", "Spring 10 pagina's vooruit")
					$(".hibb-pagination .current").attr("title", "Bewerk huidige pagina")
					$(".sort-levels .toggle").html("Sorteer op <i class='fa fa-caret-down'></i>")
					$(".sort-levels label").each((i, el) -> $(el).html($(el).html().replace("Level ", "")))
					$(".sort-levels .search button").html("Toepassen")
					$(".facet.list li[data-value=':empty'] label").html("(Leeg)")
#					$(".facet.list h3").each((i, el) -> $(el).html($(el).html().replace(/\(.+\)/, "")).attr("title", $(el).html().replace(/\(.+\)/, "")))
#					$(".facet.list[data-name='metadata_transcriptie']").hide()
					$(".facet.range[data-name='metadata_datum_range'] h3").html("Periode").attr("title", "Periode")
					$(".facet.range .slider button").attr("title", "Zoek binnen gegeven bereik")

					searchView.$el.find(".facet.range[data-name='metadata_datum_range'] h3").each (i, el) =>
						if !$(el).find(".info-icon").length
							$(el).append($("<span>").addClass("info-icon").attr("title", "Met deze schuifbalk kunnen brieven in een bepaalde periode gezocht worden. De periodegrenzen worden gespecificeerd op jaar. De selectie kan geactiveerd worden met de loep. "))



					for facetName, facetView of searchView.facets.views
						do (facetName) =>
							if !facetView.optionsView?
								return
							@stopListening facetView.optionsView, "filter:finished"
							@stopListening facetView.optionsView.collection, "sort"

							@listenTo facetView.optionsView, "filter:finished", =>
								addHover facetName

							@listenTo facetView.optionsView.collection, "sort", (collection, opts) =>
								if(opts.silent == false)
									addHover facetName


					searchView.$(".results ul.page li i.fa").on 'click', (ev) =>
						ev.stopPropagation()
						person = persons.findWhere koppelnaam: ev.currentTarget.getAttribute('data-name')
						Backbone.history.navigate "person/#{person.id}", trigger: true

					if !searchView.$el.find(".show-metadata input").is(":checked")
						searchView.$el.find(".show-metadata input").trigger("click").trigger("click")

				@listenTo searchView, 'result:click', (data) ->
					Backbone.history.navigate "entry/#{data.id}", trigger: true


				@listenTo Backbone, "search-person", (values, el) ->
					r = 0
					rotate = ->
						if el?
							el.style.transform = "rotate(" + r + "deg)"
							r++

					interv = window.setInterval(rotate, 10)

					@listenToOnce searchView, "results:render:finished", ->
						searchView.searchValue("mv_metadata_correspondents", values)

						@listenToOnce searchView, "results:render:finished", ->
							window.clearInterval(interv)
							Backbone.history.navigate "search", trigger: true
							searchView.$el.find(".facets-menu .reset button")
								.on "click", ->
									document.location.reload()
					searchView.$el.find(".facets-menu .reset button").off("click").click()

				searchView.search()

			searchView.$el.find(".show-metadata label").html("Toon metadata")
			searchView.$el.find(".text-search input[name='search']").attr("placeholder", "Zoeken in de tekst")
			searchView.$el.find(".facets-menu .reset button")
				.html("<i class='fa fa-refresh'></i> &nbsp;Nieuwe zoekvraag")
				.on "click", ->
					document.location.reload()
			searchView.$el.find(".facets-menu .collapse-expand button")
				.html("<i class='fa fa-compress'></i> &nbsp;Filters inklappen")
				.on "click", ->
					if $(this).find("i").attr('class') == 'fa fa-compress'
						$(this).html("<i class='fa fa-compress'></i> Filters uitklappen")
					else
						$(this).html("<i class='fa fa-expand'></i> Filters inklappen")
			if show
				searchView.$el.show()
				if searchView.facets.views.metadata_datum_range?
					searchView.facets.views.metadata_datum_range.postRender()
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
					labels:
						numFound: "Gevonden"
						filterOptions: "Vind..."
						sortAlphabetically: "Sorteer alfabetisch"
						sortNumerically: "Sorteer op aantal"
					termSingular: "correspondent"
					termPlural: "correspondenten"
					levels: config.get('personLevels')
					levelDisplayNames:
						dynamic_k_birthDate: "Geboortejaar"
						dynamic_k_deathDate: "Sterfjaar"
						dynamic_sort_name: "Achternaam"
						dynamic_sort_networkdomain: "Netwerk(en)"
						dynamic_sort_gender: "Geslacht"
					rangeFacetAlwaysShowButton: true
					results: true
					showMetadata: true
					templates:
						result: personResultTpl
					requestOptions:
						headers:
							VRE_ID: "CNW"
					textSearchOptions:
						caseSensitive: null
					facetOrder: [
						"dynamic_s_koppelnaam"
						"dynamic_s_altname"
						"dynamic_i_birthyear"
						"dynamic_i_deathyear"
						"dynamic_s_gender"
						"dynamic_s_networkdomain"
						"dynamic_s_characteristic"
						"dynamic_s_combineddomain"
						"dynamic_s_periodical"
						"dynamic_s_membership"
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

				addHighlight = (elem, facetName, val) ->
					found = elem.find("[data-facetname='" + facetName + "'] span.value span").filter (i, el1) => $(el1).html() == val
					found.each (i, el) => $(el).addClass("highlight")


				@listenTo personSearchView, "results:render:finished", ->
					$(".hibb-pagination .text").html("van")
					$(".hibb-pagination .prev").attr("title", "Vorige pagina")
					$(".hibb-pagination .prev10").attr("title", "Spring 10 pagina's terug")
					$(".hibb-pagination .next").attr("title", "Volgende pagina")
					$(".hibb-pagination .next10").attr("title", "Spring 10 pagina's vooruit")
					$(".hibb-pagination .current").attr("title", "Bewerk huidige pagina")
					$(".sort-levels .toggle").html("Sorteer op <i class='fa fa-caret-down'></i>")
					$(".sort-levels label").each((i, el) -> $(el).html($(el).html().replace("Level ", "")))
					$(".sort-levels select option[value='dynamic_sort_networkdomain']").html("Netwerk")

					$(".sort-levels .search button").html("Toepassen")
#					$(".facet.list li[data-value=':empty'] label").html("(Leeg)")
#					$(".facet.list li[data-value='(empty)'] label").html("(Leeg)")
					$(".facet.list h3").each((i, el) -> $(el).html($(el).html().replace(/\(.+\)/, "")).attr("title", $(el).html().replace(/\(.+\)/, "")))

					$(".facet.range .slider button").attr("title", "Zoek binnen gegeven bereik")
					$(".facet.list[data-name='dynamic_s_koppelnaam'] h3").html("Volledige naam").attr("title", "Volledige naam")
					$(".facet.list[data-name='dynamic_s_altname'] h3").html("Alternatieve naam").attr("title", "Alternatieve naam")
					$(".facet.range[data-name='dynamic_i_birthyear'] h3").html("Geboortejaar").attr("title", "Geboortejaar")
					$(".facet.range[data-name='dynamic_i_deathyear'] h3").html("Sterfjaar").attr("title", "Sterfjaar")
					$(".facet.list[data-name='dynamic_s_gender'] h3").html("Geslacht").attr("title", "Geslacht")
					$(".facet.list[data-name='dynamic_s_networkdomain'] h3").html("Netwerk").attr("title", "Netwerk")
					$(".facet.list[data-name='dynamic_s_characteristic'] h3").html("Karakteristiek").attr("title", "Karakteristiek")
					$(".facet.list[data-name='dynamic_s_membership'] h3").html("Lidmaatschap").attr("title", "Lidmaatschap")

					$(".facet.list[data-name='dynamic_s_periodical'] h3").html("Periodiek").attr("title", "Periodiek")
					$(".facet.list[data-name='dynamic_s_combineddomain'] h3").html("(Sub)domein").attr("title", "(Sub)domein")


					infoFields = [
						".facet.list[data-name='dynamic_s_characteristic'] header .menu",
						".facet.list[data-name='dynamic_s_combineddomain'] header .menu",
						".facet.list[data-name='dynamic_s_periodical'] header .menu",
						".facet.list[data-name='dynamic_s_membership'] header .menu"
					];
					personSearchView.$el.find(infoFields.join(", ")).each (i, el) =>
						if !$(el).find(".info-icon").length
							$(el).append($("<span>").addClass("info-icon").attr("title", "Selecteren van meerdere facetwaarden binnen deze facet heeft een uitbreiding van de selectie tot gevolg. Het getal achter de facetwaarde geeft het aantal treffers binnen de actieve selectie weer."))

					personSearchView.$el.find(".facet.range[data-name='dynamic_i_birthyear'] h3").each (i, el) =>
						if !$(el).find(".info-icon").length
							$(el).append($("<span>").addClass("info-icon").attr("title", "Met deze schuifbalk kunnen correspondenten gezocht worden die in een bepaalde  periode geboren zijn. De periodegrenzen worden gespecificeerd op jaar. De selectie kan geactiveerd worden met de loep."))

					personSearchView.$el.find(".facet.range[data-name='dynamic_i_deathyear'] h3").each (i, el) =>
						if !$(el).find(".info-icon").length
							$(el).append($("<span>").addClass("info-icon").attr("title", "Met deze schuifbalk kunnen correspondenten gezocht worden die in een bepaalde  periode overleden zijn. De periodegrenzen worden gespecificeerd op jaar. De selectie kan geactiveerd worden met de loep."))



					values = personSearchView.$el.find(".results .result .title").map((i, el) => $(el).clone().html().replace(/<small.*$/, "")).toArray();
					searchPersonsButton = personSearchView.$el.find(".search-for-persons-button")
					if searchPersonsButton.length == 0
						searchPersonsButton = $("<button>").addClass("search-for-persons-button")
						personSearchView.$el.find(".results-per-page").after($("<li>").html(searchPersonsButton))

					name = if values.length is 1 then "correspondent" else "correspondenten"
					personSearchView.$el.find(".show-metadata label").html("Toon metadata")

					searchPersonsButton.html("<i class='fa fa-search'></i> Zoek brieven van " + values.length + " " + name).off("click")
						.on "click", ->
							Backbone.trigger "search-person", values, $(@).find("i")[0]

					if !personSearchView.$el.find(".show-metadata input").is(":checked")
						personSearchView.$el.find(".show-metadata input").trigger("click").trigger("click")

					# CNW-44: match order of sort levels in metadata presentation
					sortLevels = personSearchView.$el.find(".sort-levels select")
						.map((i, el) => $(el).val()).toArray()
						.filter((v) => v == "dynamic_sort_networkdomain" || v == "dynamic_sort_gender")
					indexOfNetwork = sortLevels.indexOf("dynamic_sort_networkdomain")
					indexOfGender = sortLevels.indexOf("dynamic_sort_gender")
					if (indexOfNetwork > -1 and indexOfGender > -1 and indexOfNetwork < indexOfGender) or (indexOfNetwork > -1 and indexOfGender < 0)
						personSearchView.$el.find(".results .result .metadata ul").each (i, el) =>
							$(el).find("[data-facetname='dynamic_s_gender']").before($(el).find("[data-facetname='dynamic_s_networkdomain']"))


					for facetName, facetView of personSearchView.facets.views
						do (facetName, facetView) =>
							if !facetView.optionsView?
								return
							facetView.$el.find("li.checked[data-value]").each (i, el) =>
								val = $(el).attr("data-value")
								genderMap = {MALE: "Man", FEMALE: "Vrouw", UNKNOWN: "Onbekend"}
								if facetName == "dynamic_s_gender"
									val = genderMap[val]
								if val == "Verwey en Witsen"
									addHighlight personSearchView.$el, facetName, "Verwey"
									addHighlight personSearchView.$el, facetName, "Witsen"
								else
									addHighlight personSearchView.$el, facetName, val


				personSearchView.$el.find(".facets-menu .reset button")
					.html("<i class='fa fa-refresh'></i> &nbsp;Nieuwe zoekvraag")
					.on "click", (ev) ->
						ev.preventDefault()
						document.location.reload()

				personSearchView.$el.find(".facets-menu .collapse-expand button")
					.html("<i class='fa fa-compress'></i> &nbsp;Filters inklappen")
					.on "click", ->
						if $(this).find("i").attr('class') == 'fa fa-compress'
							$(this).html("<i class='fa fa-compress'></i> Filters uitklappen")
						else
							$(this).html("<i class='fa fa-expand'></i> Filters inklappen")

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
