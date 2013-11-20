define (require) ->
	us = require 'underscore.string'

	basePath = BASE_URL
	basePath = '' if basePath is '/'

	config =
		basePath: basePath
		annotationsIndex: "#{basePath}/data/annotation_index.json"
		configDataURL: "#{basePath}/data/config.json"
		itemLabel: 'entry'
		itemLabelPlural: 'entries'
		entryURL: (id, textLayer, annotation) ->
			base = "/entry/#{id}"
			if annotation? and textLayer?
				"#{base}/#{us.slugify textLayer}/#{annotation}"
			else if textLayer?
				"#{base}/#{us.slugify textLayer}"
			else 
				base
		entryDataURL: (id) -> "#{basePath}/data/#{id}.json"
		entryParallelURL: (id) -> "/entry/#{id}/parallel"
		defaultTextLayer: 'Diplomatic'
		resultRows: 25
		panelSize: 'large'
		# searchPath: "#{basePath}/api/search"
		searchPath: "http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search"

	config