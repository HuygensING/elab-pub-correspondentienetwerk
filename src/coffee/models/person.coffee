Backbone = require 'backbone'
config = require './config'

class Person extends Backbone.Model
	
	idAttribute: "_id"

	url: ->
		config.get("timbuctooBase") + config.get("timbuctooPerson") + @get('_id')

	defaults: ->
		name: ""
		koppelnaam: ""
		altNames: []
		gender: ""
		birthDate: ""
		deathDate: ""
		characteristics: []
		relatives: []
		subDomains: []
		domains: []
		networkDomains: []
		biodesurl: ""
		dbnlUrl: ""
		notities: ""
		opmerkingen: ""

module.exports = Person