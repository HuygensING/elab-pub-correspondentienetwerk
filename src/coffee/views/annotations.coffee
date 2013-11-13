define (require) ->
	Backbone = require 'backbone'

	configData = require 'models/configdata'
	config = require 'config'


	annTemplate = require 'text!html/annotations-index.html'

	Helpers = require 'helpers/string'

	# Turn long strings into "foo ... bar"
	shorten = (txt, max=50) ->
		return txt unless txt.length > max
		words = txt.split /\s+/
		firstWords = words[0..2].join(' ')
		lastWords = words.reverse()[0..2].reverse().join(' ')

	class AnnotationsView extends Backbone.View
		template: _.template annTemplate 
		className: 'annotations-index'
		initialize: ->
			jqxhr = $.getJSON(config.annotationsIndex).done (@annotations) =>
				@render()
			jqxhr.fail => console.log config.annotationsIndex, arguments

		render: ->
			@$el.html @template
				annotations: @annotations
				slugify: Helpers.slugify
				shorten: shorten
				config: config