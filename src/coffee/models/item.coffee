define (require) ->
	BaseModel = require 'models/base'
	
	class Item extends BaseModel
		url: -> "/data/#{@id}.json"

		text: (key) ->
			texts = @get 'paralleltexts'
			if texts and key of texts then texts[key].text else undefined

		annotations: (key) ->
			texts = @get 'paralleltexts'
			if texts and key of texts then texts[key].annotations else undefined