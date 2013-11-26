define (require) ->
	Backbone = require 'backbone'
	MainRouter = require 'routers/main'

	config = require 'config'

	MainController = require 'views/home'

	bootstrapTemplate = _.template require 'text!html/body.html'
	
	# Backbone expects a path, not a full URI
	rootURL = window.BASE_URL.replace /https?:\/\/[^\/]+/, ''
	
	configURL = "#{if window.BASE_URL is '/' then '' else window.BASE_URL}/data/config.json"
	initialize: ->
		config.fetch
			url: configURL,
			success: =>
				# Load first before any views,
				# so views can attach to elements
				$('body').html bootstrapTemplate()
				$('.page-header h1 a').text config.get 'title'

				mainController = new MainController el: '#main'
				mainRouter = new MainRouter
					controller: mainController
					root: rootURL
				mainRouter.start()  

				$(document).on 'click', 'a:not([data-bypass])', (e) ->
					href = $(@).attr 'href'
					
					if href?
						e.preventDefault()
						Backbone.history.navigate href, trigger: true

			error: (m, o) =>
				$('body').html 'An unknown error occurred while attempting to load the application.'

				console.error "Could not fetch config data", JSON?.stringify o
