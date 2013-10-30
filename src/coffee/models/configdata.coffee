define (require) ->
	BaseModel = require 'models/base'
	config = require 'config'
	
	class ConfigData extends BaseModel
		url: -> config.configDataURL

		findPrev: (id) ->
			ids = @get 'entryIds'
			pos = _.indexOf ids, "#{id}.json"
			ids[pos - 1]?.replace '.json', ''
		findNext: (id) ->
			ids = @get 'entryIds'
			pos = _.indexOf ids, "#{id}.json"
			ids[pos + 1]?.replace '.json', ''

		nextURL: (id) ->
			config.entryURL @findNext id
		prevURL: (id) ->
			config.entryURL @findPrev id

	new ConfigData