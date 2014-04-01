Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $

mainRouter = require './routers/main'

config = require 'elaborate-modules/modules/models/config'

entries = require 'elaborate-modules/modules/collections/entries'
textlayers = require 'elaborate-modules/modules/collections/textlayers'

# MainController = require './views/home'

# bootstrapTemplate = _.template require 'text!html/body.html'
bootstrapTemplate = require '../jade/body.jade'

# Backbone expects a path, not a full URI
rootURL = window.BASE_URL.replace /https?:\/\/[^\/]+/, ''

module.exports = ->
	jqXHR = config.fetch()
	jqXHR.done =>
		entries.add config.get('entries')
		entries.setCurrent entries.at(0)

		textlayers.add config.get('textlayers')
		textlayers.setCurrent textlayers.at(0)

		# Load first before any views,
		# so views can attach to elements
		$('body').html bootstrapTemplate()
		$('header h1 a').text config.get 'title'

		# Load the menu from WordPress
		# $.get 'http://demo4.huygens.knaw.nl/?page_id=17', => console.log arguments
		
		Backbone.history.start
			root: rootURL
			pushState: true

		$(document).on 'click', 'a:not([data-bypass])', (e) ->
			href = $(@).attr 'href'
			
			if href?
				e.preventDefault()
				Backbone.history.navigate href, trigger: true

	jqXHR.fail (m, o) =>
		$('body').html 'An unknown error occurred while attempting to load the application.'

		console.error "Could not fetch config data", JSON?.stringify o