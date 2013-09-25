define (require) ->
	basePath = window.location.pathname

	# Perhaps not the best way to ensure relative paths refer to correct location
	basePath = basePath.replace /\/(?:entry(?:\/\d+))/, '/'
	console.log "BASE PATH", basePath

	config =
		appRootElement: '#app'
		baseURL: ''
		configDataURL: "#{basePath}data/config.json"
		entryURL: (id) -> "#{basePath}entry/#{id}"
		entryDataURL: (id) -> 
			console.log "Fetching entry #{id}"
			"#{basePath}data/#{id}.json"
		parallelURL: (id) -> "#{basePath}entry/#{id}/parallel"
		defaultTextVersion: 'Diplomatic'
		resultRows: 10
		panelSize: 'large'
		# searchPath: 'http://demo7.huygens.knaw.nl/elab4-clusius_correspondence/api/search'
		searchPath: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search'

	console.log config

	config