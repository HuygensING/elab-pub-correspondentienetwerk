define (require) ->
	Backbone = require 'backbone'

	config = require 'config'
	configData = require 'models/configdata'

	FacetedSearch = require '../../lib/faceted-search/stage/js/main'

	Templates =
		Search: require 'text!html/search.html'
		ResultsList: require 'text!html/results-list.html'

	class Home extends Backbone.View
		className: 'wrapper'
		events:
			'click .results .body li': 'resultClicked'
			'click .results .next': 'nextResults'
			'click .results .previous': 'previousResults'
			'change .sort select': 'sortResults'

		initialize: ->
			@template = _.template Templates.Search
			@resultsTemplate = _.template Templates.ResultsList
			@render()

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

		nextResults: ->
			@showLoader()
			@search.next()
		previousResults: ->
			@showLoader()
			@search.prev()

		sortResults: (e) ->
			@sortField = $(e.currentTarget).val()
			@search.sortResultsBy(@sortField)

		renderSortableFields: ->
			if @sortableFields
				select = $('<select>')
				for f in @sortableFields
					option = $('<option>')
						.attr(value: f)
						.text(config.sortableFieldNames?[f] || f)
					option.attr('selected','selected') if @sortField and @sortField is f
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
			@$('.results .list ol').css 'counter-reset': "item #{start}"

			@renderResultsCount()

			@$('.position .current').text @search.currentPosition?()
			@$('.position .total').text @search.numPages?()
			@hideLoader()

			@renderSortableFields()
			@renderCursor()

		render: ->
			document.title = configData.get 'title'
			@$el.html @template w: configData.get 'entryIds'

			@search = new FacetedSearch
				searchPath: config.searchPath
				queryOptions:
					resultRows: config.resultRows
					term: '*'

			@search.subscribe 'faceted-search:results', (response) =>
				@results = response
				if 'sortableFields' of response
					@sortableFields = response.sortableFields
				@renderResults()

			@$('.faceted-search').html @search.$el

			@