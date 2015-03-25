Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'


persons = require '../collections/persons'
Person = require '../models/person'
config= require '../models/config'

tpl = require '../../jade/person.jade'

funcky = require 'funcky.req'

class PersonView extends Backbone.View

	className: 'person'

	initialize: (@options) ->
		console.log @options.id
		@model = persons.get @options.id

		@render()

	_showButton: ->
		@$('i.fa-search').css 'opacity', 1

	_checkLetterFacetedSearch: ->
		if config.get('isLetterFacetedSearchLoaded')
			@_showButton()
		else
			@listenToOnce Backbone, "letter-faceted-search-loaded", =>
				@_showButton()
	render: ->
		@$el.html tpl model: @model

		@_checkLetterFacetedSearch()

		@

	events: ->
		"click span.link": "handlePersonClick"
		"click i.fa-search": "handleSearch"
		"click .lees-meer > button": "_handleLeesmeer"

	handlePersonClick: (ev) ->
		person = persons.findWhere koppelnaam: ev.currentTarget.innerHTML
		Backbone.history.navigate "person/#{person.id}", trigger: true

	handleSearch: (ev) ->
		Backbone.trigger "search-person", @model.get('koppelnaam')

	###
	# When the lees-meer button is clicked, the button is hidden
	# and the attributes become visible. Once clicked, the attributes
	# cannot be hidden anymore and will remain visible.
	#
	# @method
	# @param {Object} ev
	###
	_handleLeesmeer: (ev) ->
		leesMeer = @$('.lees-meer')

		leesMeer.find('button').hide()
		leesMeer.find('ul').show()
		
	destroy: ->
		@remove()

module.exports = PersonView