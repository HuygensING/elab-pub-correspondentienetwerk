Backbone = require 'backbone'
$ = require 'jquery'
Backbone.$ = $

mainRouter = require './routers/main'

config = require './models/config'

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
		jqXHR = $.get '../external/'
		jqXHR.done (menuDiv) => 
			menuDiv = $(menuDiv)
			if menuDiv.hasClass 'menu-mainmenu-container'
				a.setAttribute 'data-bypass', true for a in menuDiv.find 'a'
				$('header > ul').after menuDiv
			# DEV ONLY
			# else
			# 	menuDiv = $ '<div class="menu-mainmenu-container"><ul id="menu-mainmenu" class="menu"><li id="menu-item-13" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-13"><a href="/">Home</a></li>
			# 		<li id="menu-item-14" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-14"><a href="/edition">Online edition</a></li>
			# 		<li id="menu-item-12" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12"><a href="http://deystroom.huygens.knaw.nl/introduction/">Introduction</a></li>
			# 		<li id="menu-item-11" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-11"><a href="http://deystroom.huygens.knaw.nl/about-this-edition/">About this edition</a></li>
			# 		</ul></div>'
			# 	a.setAttribute 'data-bypass', true for a in menuDiv.find 'a'
			# 	$('header > ul').after menuDiv
		
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