define (require) ->
	Backbone = require 'backbone'
	
	configData = require 'models/configdata'

	SearchView = require 'views/search'

	class Home extends Backbone.View
		template: require 'text!html/home.html'
		initialize: ->
			@searchView = new SearchView
			@render()

		render: ->
			console.log "Hioem render"
			@template = _.template @template
			@$el.html @template()
			@$('h1').text configData.get 'title'

			@$el.append @searchView.$el

			@