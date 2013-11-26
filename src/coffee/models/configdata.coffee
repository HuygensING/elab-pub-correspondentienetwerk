define (require) ->
	BaseModel = require 'models/base'
	config = require 'config'

	us = require 'underscore.string'

	class ConfigData extends BaseModel
		defaults:
			textLayer: 'Diplomatic'

		parse: (data) ->
			data.entryIds = []
			data.entryNames = {}
			for e in data.entries
				id = e['datafile']
				data.entryIds.push id
				data.entryNames[id] = e['name']
			data

		entryName: (id) -> @get('entryNames')[id]

		findPrev: (id) ->
			ids = @get 'entryIds'
			pos = _.indexOf ids, "#{id}.json"
			ids[pos - 1]?.replace '.json', ''
		findNext: (id) ->
			ids = @get 'entryIds'
			pos = _.indexOf ids, "#{id}.json"
			ids[pos + 1]?.replace '.json', ''

		nextURL: (id) ->
			next = @findNext id
			config.entryURL next if next
		prevURL: (id) ->
			prev = @findPrev id
			config.entryURL prev if prev

		slugToLayer: (slug) ->
			for layer in @get('textLayers') || []
				if slug is us.slugify layer
					return layer

	new ConfigData