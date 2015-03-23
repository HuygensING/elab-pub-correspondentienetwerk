Backbone = require 'backbone'

config = require '../models/config'
Person = require '../models/person'

class Persons extends Backbone.Collection

	model: Person

	url: ->
		config.get("timbuctooBase") + config.get("timbuctooPerson") + "?rows=500"

module.exports = new Persons()