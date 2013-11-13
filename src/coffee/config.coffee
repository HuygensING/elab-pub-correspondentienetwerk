define (require) ->
	basePath = BASE_URL
	basePath = '' if basePath is '/'

	config =
		basePath: basePath
		annotationsIndex: "#{basePath}/data/annotation_index.json"
		configDataURL: "#{basePath}/data/config.json"
		itemLabel: 'entry'
		itemLabelPlural: 'entries'
		entryURL: (id) -> "/entry/#{id}"
		entryDataURL: (id) -> "#{basePath}/data/#{id}.json"
		parallelURL: (id) -> "/entry/#{id}/parallel"
		defaultTextVersion: 'Diplomatic'
		resultRows: 10
		panelSize: 'large'
		searchPath: "#{basePath}/api/search"

	config