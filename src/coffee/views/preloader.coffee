Backbone = require 'backbone'
$ = require 'jquery'

class Preloader extends Backbone.View
	id: 'js-image-preloader'

	start: -> $('body').append @$el

	loadImage: (src, onLoaded) ->
		img = new Image
		if img.addEventListener
			img.addEventListener 'load', -> onLoaded(src)
		else
			img.attachEvent 'onload', -> onLoaded(src)
		img.src = src

module.exports = new Preloader()