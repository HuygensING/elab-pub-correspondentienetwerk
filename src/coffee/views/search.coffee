define (require) ->
	config = require 'config'
	entriesList = JSON.parse require 'text!../../../data/config.json'
	BaseView = require 'views/base'
	FacetedSearch = require '../../lib/faceted-search/stage/js/main'
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

			fs = new FacetedSearch
				searchUrl: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search' # config.searchPath
				queryOptions:
					resultRows: config.resultRows
					term: '*'

			@$('.faceted-search').html fs.$el

			@