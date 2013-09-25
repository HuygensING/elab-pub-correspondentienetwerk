define (require) ->
	BaseModel = require 'models/base'
	config = require 'config'
	
	class ConfigData extends BaseModel
		url: -> config.configDataURL
		findPrev: (id) ->
			ids = @get 'entryIds'
			pos = ids.indexOf "#{id}.json"
			ids[pos - 1]?.replace '.json', ''
		findNext: (id) ->
			ids = @get 'entryIds'
			pos = ids.indexOf "#{id}.json"
			ids[pos + 1]?.replace '.json', ''

	new ConfigData