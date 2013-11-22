define (require) ->
	Backbone = require 'backbone'

	configData = require 'models/configdata'
	config = require 'config'

	us = require 'underscore.string'

	annTemplate = require 'text!html/annotations-index.html'

	# Turn long strings into "foo ... bar"
	shorten = (txt, max=50) ->
		return txt unless txt.length > max
		words = txt.split /\s+/
		firstWords = words[0..2].join(' ')
		lastWords = words.reverse()[0..2].reverse().join(' ')

	class AnnotationsView extends Backbone.View
		template: _.template annTemplate 
		className: 'annotations-index'
		events:
			'click .print': 'printEntry'

		initialize: ->
			jqxhr = $.getJSON(config.annotationsIndex).done (@annotations) =>
				@render()
			jqxhr.fail => console.log config.annotationsIndex, arguments

		printEntry: (e) ->
			e.preventDefault()
			window.print()

		render: ->
			@$el.html @template
				annotations: @annotations
				shorten: shorten
				slugify: us.slugify
				config: config