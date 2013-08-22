define (require) ->
	config = require 'config'
	entriesList = JSON.parse require 'text!../../../data/config.json'
	BaseView = require 'views/base'
	# FacetedSearch = require '../../lib/faceted-search/stage/js/main'
	Templates =
		Search: require 'text!html/search.html'

	class Home extends BaseView
		events:
			'click .results li': 'cl'

		initialize: ->
			super

			@render()

		cl: (e) ->
			console.log "Clicked ", $(e.currentTarget).text()

		render: ->
			rtpl = _.template Templates.Search
			# console.log entriesList
			@$el.html rtpl w: entriesList

			# fs = new FacetedSearch
			# 	searchUrl: config.searchPath
			# 	queryOptions:
			# 		resultRows: config.resultRows
			# 		term: '*'
			# 		sort: 'facet_sort_name'

			# @$('.faceted-search').html fs.$el

			@