define (require) ->
	Backbone = require 'backbone'
	MainRouter = require 'routers/main'
	configData = require 'models/configdata'
	Views = Header: require 'views/ui/header'

	initialize: ->
		configData.fetch
			success: =>
				mainRouter = new MainRouter()

				header = new Views.Header
					managed: false
					title: configData.get 'title'
				$('header.wrapper').prepend header.$el
				Backbone.history.start
					root: window.location.pathname
					pushState: true   

				$(document).on 'click', 'a:not([data-bypass])', (e) ->
					href = $(@).attr 'href'
					
					if href?
						e.preventDefault()
						Backbone.history.navigate href, trigger: true
		error: => console.log "Could not fetch config data"
