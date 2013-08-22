define (require) ->
	BaseModel = require 'models/base'
	
	class Item extends BaseModel
		url: -> "/data/#{@id}.json"