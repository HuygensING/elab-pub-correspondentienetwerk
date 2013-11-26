define (require) ->
	Backbone = require 'backbone'
	us = require 'underscore.string'

	basePath = BASE_URL
	basePath = '' if basePath is '/'

	class Config extends Backbone.Model
		defaults:
			textLayer: 'Diplomatic'
			basePath: basePath
			annotationsIndex: "#{basePath}/data/annotation_index.json"
			configDataURL: "#{basePath}/data/config.json"
			itemLabel: 'entry'
			itemLabelPlural: 'entries'
			defaultTextLayer: 'Diplomatic'
			resultRows: 25
			panelSize: 'large'
			# searchPath: "#{basePath}/api/search"
			searchPath: "http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search"

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
			@entryURL next if next
		prevURL: (id) ->
			prev = @findPrev id
			@entryURL prev if prev

		entryURL: (id, textLayer, annotation) ->
			base = "/entry/#{id}"
			if annotation? and textLayer?
				"#{base}/#{us.slugify textLayer}/#{annotation}"
			else if textLayer?
				"#{base}/#{us.slugify textLayer}"
			else 
				base

		entryDataURL: (id) -> "#{@get 'basePath'}/data/#{id}.json"
		entryParallelURL: (id) -> "/entry/#{id}/parallel"

		slugToLayer: (slug) ->
			for layer in @get('textLayers') || []
				if slug is us.slugify layer
					return layer

	new Config