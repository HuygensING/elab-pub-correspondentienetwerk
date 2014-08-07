class Preloader
	loadImage: (src, onLoaded) ->
		img = new Image
		if img.addEventListener
			img.addEventListener 'load', -> onLoaded(src)
		else
			img.attachEvent 'onload', -> onLoaded(src)
		img.src = src

module.exports = new Preloader()