define (require) ->
	Backbone = require 'backbone'
	
	configData = require 'models/configdata'

	SearchView = require 'views/search'
	EntryView = require 'views/entry'
	AnnotationsView = require 'views/annotations'

	events = require 'events'

	class Home extends Backbone.View
		template: require 'text!html/home.html'
		initialize: ->
			@searchView = new SearchView
			@entryView = new EntryView
			@annotationsView = new AnnotationsView

			events.on 'change:view:entry', =>
				@searchView.$el.hide()
				@annotationsView.$el.hide()
				@entryView.$el.show()
			events.on 'change:view:annotations', =>
				@searchView.$el.hide()
				@entryView.$el.hide()
				@annotationsView.$el.show()
			events.on 'change:view:search', =>
				@entryView.$el.hide()
				@annotationsView.$el.hide()
				@searchView.$el.show()
			
			@render()

		render: ->
			# @template = _.template @template
			# @$el.html @template()
			# @$('h1').text configData.get 'title'

			@$el.append @searchView.$el
			@$el.append @entryView.$el
			@$el.append @annotationsView.$el

			@