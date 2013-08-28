define (require) ->
	BaseModel = require 'models/base'
	
	class ConfigData extends BaseModel
		url: -> "/data/config.json"
		findPrev: (id) ->
			ids = @get 'entryIds'
			pos = ids.indexOf "#{id}.json"
			ids[pos - 1]
		findNext: (id) ->
			ids = @get 'entryIds'
			pos = ids.indexOf "#{id}.json"
			ids[pos + 1]

	new ConfigData