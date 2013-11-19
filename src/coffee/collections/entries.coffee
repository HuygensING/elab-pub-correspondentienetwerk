define (require) ->
	Backbone = require 'backbone'
	Entry = require 'models/entry'

	class Entries extends Backbone.Collection
		model: Entry