define (require) ->
	basePath = BASE_URL
	basePath = '' if basePath is '/'

	console.log "SEARHC PATH", basePath

	config =
		configDataURL: "#{basePath}/data/config.json"
		itemLabel: 'entry'
		itemLabelPlural: 'entries'
		entryURL: (id) -> "#{basePath}/entry/#{id}"
		entryDataURL: (id) -> 
			console.log "Fetching entry #{id}"
			"#{basePath}/data/#{id}.json"
		parallelURL: (id) -> "#{basePath}/entry/#{id}/parallel"
		defaultTextVersion: 'Diplomatic'
		resultRows: 10
		panelSize: 'large'
		searchPath: "#{basePath}/api/search"

	config