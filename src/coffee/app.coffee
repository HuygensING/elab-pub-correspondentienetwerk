define (require) ->
	Backbone = require 'backbone'
	MainRouter = require 'routers/main'

	configData = require 'models/configdata'
	config = require 'config'

	Views =
		Main: require 'views/home'

	bootstrapTemplate = _.template require 'text!html/body.html'

	configURL = "#{if window.BASE_URL is '/' then '' else window.BASE_URL}/data/config.json"
	console.log "Loading #{configURL}"

	initialize: ->
		configData.fetch
			url: configURL,
			success: =>
				# Load first before any views,
				# so views can attach to elements
				$('body').html bootstrapTemplate()
				$('header h1').text configData.get 'title'

				mainRouter = new MainRouter
				mainView = new Views.Main el: '#main'

				Backbone.history.start
					root: config.basePath || ''
					pushState: true   

				$(document).on 'click', 'a:not([data-bypass])', (e) ->
					href = $(@).attr 'href'
					
					if href?
						e.preventDefault()
						Backbone.history.navigate href, trigger: true
			error: => console.log "Could not fetch config data"
