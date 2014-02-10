# TODO Remove shorten

Backbone = require 'backbone'
$ = require 'jquery'
_ = require 'underscore'

config = require 'elaborate-modules/modules/models/config'

us = require 'underscore.string'

# Turn long strings into "foo ... bar"
shorten = (txt, max=50) ->
	return txt unless txt.length > max
	words = txt.split /\s+/
	firstWords = words[0..2].join(' ')
	lastWords = words.reverse()[0..2].reverse().join(' ')

tpl = require '../../jade/annotation-overview/index.jade'
typeTpl = require '../../jade/annotation-overview/section.jade'

class AnnotationsView extends Backbone.View

	className: 'annotations-index'

	# ### Initialize
	initialize: (@options={}) ->
		jqxhr = $.getJSON(config.get 'annotationsIndexPath').done (@annotations) =>
			@types = _.sortBy(_.keys(@annotations), (t) -> t.toLowerCase())
			@render()
		jqxhr.fail => console.log config.get('annotationsIndexPath'), arguments

		$(window).resize @adjustContentHeight

	# ### Render
	render: ->
		@$el.html tpl
			types: _.map @types, (t) =>
				name: t
				count: @annotations[t].length
			shorten: shorten
			slugify: us.slugify
			config: config

		@renderType _.first @types

		setTimeout @adjustContentHeight, 100
		

	renderType: (type) -> @renderContents @typeHTML type

	renderContents: (html) ->
		@$('.contents').fadeOut 75,
			=> @$('.contents').html(html).fadeIn 75	

	
	# ### Events
	events:
		'click .print': 'printEntry'
		'click ul.annotation-types li.all a': 'selectAllTypes'
		'click ul.annotation-types li a': 'selectType'

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
		@renderContents html

	# ### Methods

	adjustContentHeight: => @$('.contents').height $(window).height() - @$('.contents').offset().top

	typeHTML: (type) ->
		return unless type?
		typeTpl
			type: type
			annotations: @annotations[type]
			shorten: shorten
			slugify: us.slugify
			config: config

module.exports = AnnotationsView