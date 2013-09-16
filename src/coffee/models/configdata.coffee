define (require) ->
	BaseModel = require 'models/base'
	config = require 'config'
	
	class ConfigData extends BaseModel
		url: -> config.configDataURL
		findPrev: (id) ->
			ids = @get 'entryIds'
			pos = ids.indexOf "#{id}.json"
			ids[pos - 1]
		findNext: (id) ->
			ids = @get 'entryIds'
			pos = ids.indexOf "#{id}.json"
			ids[pos + 1]

	new ConfigData