$ = require 'jquery'
app = require './app'
json3 = require 'json3'

$ ->
	# Doing this here before Backbone starts parsing stuff
	window.JSON = json3
	
	app()