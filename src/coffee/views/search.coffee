define (require) ->
	Backbone = require 'backbone'

	config = require 'config'

	FacetedSearch = require 'faceted-search/stage/js/main'

	Templates =
		Search: require 'text!html/search.html'
		ResultsList: require 'text!html/results-list.html'

	class Home extends Backbone.View
		className: 'wrapper'
		events:
			'click button.reset': 'resetSearch'
			'click .results .body li': 'resultClicked'
			'click .results .next': 'nextResults'
			'click .results .previous': 'previousResults'
			'change .sort select': 'sortResults'

		initialize: ->
			@template = _.template Templates.Search
			@resultsTemplate = _.template Templates.ResultsList
			@render()

		resetSearch: ->
			@search.reset()

		showLoader: ->
			@displayLoader = true
			doIt = =>
				if @displayLoader
					@$('.position').hide()
					@$('.loader').fadeIn('fast')
			_.delay doIt, 200

		hideLoader: ->
			@displayLoader = false
			@$('.position').fadeIn 'fast'
			@$('.loader').fadeOut 'fast'

		numPages: ->
			@results = @search.model.searchResults.current
			Math.ceil @results.get('numFound') / config.get 'resultRows'

		currentPosition: ->
			@results = @search.model.searchResults.current
			1 + (@results.get('start') / config.get 'resultRows')

		nextResults: ->
			@showLoader()
			@search.next()
		previousResults: ->
			@showLoader()
			@search.prev()

		sortResults: (e) ->
			@sortField = $(e.currentTarget).val()
			@search.sortResultsBy @sortField

		renderSortableFields: ->
			if @sortableFields
				select = $('<select>')
				for field, name of @sortableFields
					option = $('<option>')
						.attr(value: field)
						.text(name)
					option.attr('selected','selected') if @sortField and @sortField is field
					select.append(option)

				@$('.controls .sort').empty().append '<span>Order by&nbsp;</span>'
				@$('.controls .sort').append select

			@

		renderResultsCount: ->
			@$('.results h3 .number-of-results').text(@results.numFound)

		renderCursor: ->
			@$('.cursor').toggle @search.hasNext() or @search.hasPrev()
			@$('.cursor .next').toggle @search.hasNext()
			@$('.cursor .previous').toggle @search.hasPrev()

		renderResults: ->
			@$('.results .list').html @resultsTemplate
				results: @results
				config: config

			start = @results.start + 1
			@$('.results .list ol').attr start: start
			@renderResultsCount()

			@$('.results .list').hide().fadeIn 125

			@$('.position .current').text @currentPosition()
			@$('.position .total').text @numPages()
			@hideLoader()

			@renderSortableFields()
			@renderCursor()

		render: ->
			document.title = config.get 'title'
			@$el.html @template w: config.get 'entryIds'

			firstSearch = true
			@search = new FacetedSearch
				searchPath: config.get 'searchPath'
				textSearchOptions:
					textLayers: config.get 'textLayers'
					searchInAnnotations: true
					searchInTranscriptions: true
				queryOptions:
					resultRows: config.get 'resultRows'
					term: '*'

			@listenTo @search, 'reset', =>
				firstSearch = true
			@listenTo @search, 'results:change', (responseModel) =>
				@results = responseModel.attributes

				totalEntries = config.get('entryIds').length
				firstSearch = false

				config.set allResultIds: @results.allIds

				if @results.sortableFields?
					@sortableFields = {}
					for f in @results.facets when f.name in @results.sortableFields
						@sortableFields[f.name] = f.title 
				@renderResults()
				
			@$('.faceted-search').html @search.$el
			@$('.faceted-search')

			@