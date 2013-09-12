define (require) ->
	config =
		appRootElement: '#app'
		baseURL: ''
		itemURL: (id) -> "/item/#{String(id).replace '.json', ''}"
		parallelURL: (id) -> "/item/#{id}/parallel"
		defaultTextVersion: 'Diplomatic'
		resultRows: 10
		panelSize: 'large'
		# searchPath: 'http://demo7.huygens.knaw.nl/elab4-clusius_correspondence/api/search'
		searchPath: 'http://demo7.huygens.knaw.nl/elab4-gemeentearchief_kampen/api/search'