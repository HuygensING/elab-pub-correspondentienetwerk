define (require) ->
	Backbone = require 'backbone'

	configData = require 'models/configdata'
	config = require 'config'

	us = require 'underscore.string'

	# Turn long strings into "foo ... bar"
	shorten = (txt, max=50) ->
		return txt unless txt.length > max
		words = txt.split /\s+/
		firstWords = words[0..2].join(' ')
		lastWords = words.reverse()[0..2].reverse().join(' ')

	class AnnotationsView extends Backbone.View
		template: _.template require 'text!html/annotations-index.html'
		typeTemplate: _.template require 'text!html/annotations-section.html'
		className: 'annotations-index'
		events:
			'click .print': 'printEntry'
			'click .list li.all a': 'selectAllTypes'
			'click .list li a': 'selectType'

		initialize: (@options={}) ->
			jqxhr = $.getJSON(config.annotationsIndex).done (@annotations) =>
				@types = _.sortBy(_.keys(@annotations), (t) -> t.toLowerCase())
				@render()
			jqxhr.fail => console.log config.annotationsIndex, arguments

		printEntry: (e) ->
			e.preventDefault()
			window.print()

		selectType: (e) ->
			type = $(e.currentTarget).attr 'data-type'
			@renderType type
			e.preventDefault()

		selectAllTypes: ->
			html = ""
			html += @typeHTML type for type in @types
			@renderContents  html

		typeHTML: (type) ->
			html = @typeTemplate
				type: type
				annotations: @annotations[type]
				shorten: shorten
				slugify: us.slugify
				config: config
				configData: configData

		renderType: (type) ->
			@renderContents @typeHTML type

		renderContents: (html) ->
			@$('.contents').fadeOut 75,
				=> @$('.contents').html(html).fadeIn 75	

		render: ->
			@$el.html @template
				types: _.map @types, (t) =>
					name: t
					count: @annotations[t].length
				shorten: shorten
				slugify: us.slugify
				config: config

			@renderType _.first @types
