define (require) ->
	Backbone = require 'backbone'
	Collections =
		'View': require 'collections/view'

	class ViewManager

		currentViews = new Collections.View()

		debugCurrentViews: currentViews

		selfDestruct = (view) ->
			if not currentViews.has(view)
				console.error 'Unknown view!'
				return false;

			if view.destroy then view.destroy() else view.remove()

		constructor: ->
			# TODO: Make div#main optional
			@main = $ 'div#main'


		clear: (view) ->
			# Remove one view
			if view
				selfDestruct view 
				currentViews.remove view.cid
			# Remove all views
			else
				currentViews.each (model) ->
					selfDestruct model.get('view')
				currentViews.reset()


		register: (view) ->
			if view
				currentViews.add
					'id': view.cid
					'view': view


		show: (View, query) ->
			@clear() # Clear previous views

			query = query || {}
			view = new View query

			html = if not view? then '' else view.$el

			@main.html html

	new ViewManager();