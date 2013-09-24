define (require) ->
	config = require 'config'
	configData = require 'models/configdata'

	entriesList = JSON.parse require 'text!../../../data/config.json'
	BaseView = require 'views/base'
	FacetedSearch = require '../../lib/faceted-search/stage/js/main'
	Templates =
		Search: require 'text!html/search.html'
		ResultsList: require 'text!html/results-list.html'

	class Home extends BaseView
		className: 'wrapper'
		events:
			'click .results .body li': 'resultClicked'
			'click .results .next': 'nextResults'
			'click .results .previous': 'previousResults'
			'change .sort select': 'sortResults'

		initialize: ->
			super
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
			console.log "Has next/prev", @search.hasNext(), @search.hasPrev()
			@$('.cursor').toggle @search.hasNext() or @search.hasPrev()
			@$('.cursor .next').toggle @search.hasNext()
			@$('.cursor .previous').toggle @search.hasPrev()

		renderResults: ->
			@$('.results .list').html @resultsTemplate
				results: @results
				config: config
			@renderResultsCount()

			@$('.position .current').text @search.currentPosition?()
			@$('.position .total').text @search.numPages?()
			@$('.position').show()
			@$('.loader').hide()

			@renderSortableFields()
			@renderCursor()

		render: ->
			$('title').text configData.get 'title'
			@$el.html @template w: entriesList

			@search = new FacetedSearch
				searchPath: config.searchPath
				queryOptions:
					resultRows: config.resultRows
					term: '*'

			@search.subscribe 'results:change', (response) =>
				@results = response
				if 'sortableFields' of response
					@sortableFields = response.sortableFields
				@renderResults()

			@$('.faceted-search').html @search.$el

			@