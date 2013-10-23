define (require) ->
	Backbone = require 'backbone'
	
	configData = require 'models/configdata'

	SearchView = require 'views/search'
	EntryView = require 'views/entry'

	events = require 'events'

	class Home extends Backbone.View
		template: require 'text!html/home.html'
		initialize: ->
			@searchView = new SearchView
			@entryView = new EntryView

			events.on 'change:view:entry', =>
				@searchView.$el.hide()
				@entryView.$el.show()
			events.on 'change:view:search', =>
				@entryView.$el.hide()
				@searchView.$el.show()
			
			@render()

		render: ->
			# @template = _.template @template
			# @$el.html @template()
			# @$('h1').text configData.get 'title'

			@$el.append @searchView.$el
			@$el.append @entryView.$el

			@