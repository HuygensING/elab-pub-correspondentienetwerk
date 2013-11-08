define (require) ->
	Backbone = require 'backbone'
	MainRouter = require 'routers/main'

	configData = require 'models/configdata'
	config = require 'config'

	Views =
		Main: require 'views/home'

	bootstrapTemplate = _.template require 'text!html/body.html'
	
	# Backbone expects a path, not a full URI
	rootURL = window.BASE_URL.replace /https?:\/\/[^\/]+/, ''

	
	configURL = "#{if window.BASE_URL is '/' then '' else window.BASE_URL}/data/config.json"
	initialize: ->
		configData.fetch
			url: configURL,
			success: =>
				# Load first before any views,
				# so views can attach to elements
				$('body').html bootstrapTemplate()
				$('header h1 a').text configData.get 'title'

				mainRouter = new MainRouter
				mainView = new Views.Main el: '#main'

				Backbone.history.start
					root: rootURL
					pushState: true   

				$(document).on 'click', 'a:not([data-bypass])', (e) ->
					href = $(@).attr 'href'
					
					if href?
						e.preventDefault()
						Backbone.history.navigate href, trigger: true
			error: (m, o) => console.log "Could not fetch config data", JSON.stringify o
