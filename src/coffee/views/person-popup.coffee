Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'


persons = require '../collections/persons'
Person = require '../models/person'
# config= require '../models/config'

tpl = require '../../jade/person-popup.jade'

class PersonPopup extends Backbone.View

	className: 'person-popup'

	initialize: (@options) ->
		@models = @options.ids.map (id) -> persons.get id

		@render()

	render: ->
		@$el.css left: @options.position.left + 15
		@$el.css top: @options.position.top + @options.height + 10

		for model in @models
			@$el.append  tpl model: model

		$('body').prepend @el

	events: ->
		
	destroy: ->
		@remove()

module.exports = PersonPopup