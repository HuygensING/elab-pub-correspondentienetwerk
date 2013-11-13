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
			next = @findNext id
			config.entryURL next if next
		prevURL: (id) ->
			prev = @findPrev id
			config.entryURL prev if prev

	new ConfigData