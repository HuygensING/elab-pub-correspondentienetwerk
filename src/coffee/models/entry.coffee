define (require) ->
	BaseModel = require 'models/base'
	config = require 'config'
	
	class Entry extends BaseModel
		url: config.entryDataURL

		parse: (data) ->
			# Replace <ab />s (annotation begin) and <ae />s (annotation end) with <span />s and <sup />s
			if data.paralleltexts?
				for version of data.paralleltexts
					i = 1
					data.paralleltexts[version].text = data.paralleltexts[version].text.replace /<ab id="(.*?)"\/>/g, (match, p1, offset, string) => '<span data-marker="begin" data-id="'+p1+'"></span>'
					data.paralleltexts[version].text = data.paralleltexts[version].text.replace /<ae id="(.*?)"\/>/g, (match, p1, offset, string) => '<sup data-marker="end" data-id="'+p1+'">'+(i++)+'</sup> '
			data

		text: (key) ->
			texts = @get 'paralleltexts'
			if texts and key of texts then texts[key].text else undefined

		textVersions: ->
			key for key of @get 'paralleltexts'

		annotations: (key) ->
			texts = @get 'paralleltexts'
			if texts and key of texts then texts[key].annotations else undefined

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
