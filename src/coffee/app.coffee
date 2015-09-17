Backbone = require 'backbone'
$ = require 'jquery'
$.support.cors = true;
Backbone.$ = $

mainRouter = require './routers/main'

config = require './models/config'

entries = require './collections/entries'
textlayers = require './collections/textlayers'
persons = require './collections/persons'

# MainController = require './views/home'

# bootstrapTemplate = _.template require 'text!html/body.html'
bootstrapTemplate = require '../jade/body.jade'

# Backbone expects a path, not a full URI
rootURL = window.BASE_URL.replace /https?:\/\/[^\/]+/, ''

module.exports = ->
	jqXHR = persons.fetch()
	jqXHR.done =>
		fetched()

	jqXHR.fail =>
		for arg in arguments
			console.log arg

	config.fetch().done =>
		fetched()

	count = 0
	fetched = ->
		count = count + 1

		if count is 2
			entries.add config.get('entries')
			entries.setCurrent entries.at(0)

			textlayers.add config.get('textlayers')
			textlayers.setCurrent textlayers.at(0)

			# Load first before any views,
			# so views can attach to elements
			$('body').html bootstrapTemplate()
			$('header h1 a').text "Brieven en Correspondenten rond 1900"

			# Load the menu from WordPress
			$.get('../external/').done (menuDiv) => 
				menuDiv = $(menuDiv)
				if menuDiv.hasClass 'menu-mainmenu-container'
					a.setAttribute 'data-bypass', true for a in menuDiv.find 'a'
					$('header > ul').after menuDiv

			Backbone.history.start
				root: rootURL
				pushState: true

			$(document).on 'click', 'a:not([data-bypass])', (e) ->
				href = $(@).attr 'href'
				
				if href?
					e.preventDefault()
					Backbone.history.navigate href, trigger: true

	# jqXHR.fail (m, o) =>
	# 	$('body').html 'An unknown error occurred while attempting to load the application.'

	# 	console.error "Could not fetch config data", JSON?.stringify o