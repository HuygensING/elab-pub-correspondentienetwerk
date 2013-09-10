define (require) ->
	config =
		appRootElement: '#app'
		baseURL: ''
		itemURL: (id) -> "/item/#{String(id).replace '.json', ''}"
		resultRows: 10