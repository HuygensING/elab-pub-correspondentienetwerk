define (require) ->
	BaseModel = require 'models/base'
	config = require 'config'

	class Entry extends BaseModel
		url: -> config.entryDataURL(@id)

		parse: (data) ->
			# Replace <ab />s (annotation begin) and <ae />s (annotation end) with <span />s and <sup />s
			if data.paralleltexts?
				for version of data.paralleltexts
					i = 1
					text = data.paralleltexts[version].text
					text = '<div class="line">' + text.replace(/\n|<br>/g, '</div><div class="line">') + '</div>'
					text = text.replace /(<div class="line">)(\s*<span[^>]+><\/span>\s*)?\s*(<\/div>)/mg, "$1$2&nbsp;$3"
					text = text.replace /^<div class="line">&nbsp;<\/div>$/mg, ''

					data.paralleltexts[version].text = text

			# TODO: make permanent? (ask BramB)
			for page in data.facsimiles
				page.zoom = page.zoom.replace 'adore-huygens-viewer-2.0', 'adore-huygens-viewer-2.1'
			data

		text: (key) ->
			texts = @get 'paralleltexts'
			if texts and key of texts then texts[key].text else undefined

		textLayers: ->
			_.keys @get 'paralleltexts'


		annotations: (key) ->
			texts = @get 'paralleltexts'
			if texts and key of texts then texts[key].annotations else undefined

		facsimileZoomURL: (page) ->
			@get('facsimiles')?[page]?.zoom

		facsimileURL: (options) ->
			sizes =
				small: 2
				medium: 3
				large: 4

			size = options?.size || 'medium'
			level = sizes[size]

			facsimiles = @get 'facsimiles'
			url = facsimiles[0].thumbnail

			url.replace /svc.level=\d+/, "svc.level=#{level}"
