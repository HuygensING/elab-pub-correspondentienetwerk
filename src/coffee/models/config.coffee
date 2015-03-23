Backbone = require 'backbone'
us = require 'underscore.string'

pck = require "../../../package.json"

baseUrl = if window.BASE_URL is "/" then "" else window.BASE_URL

class Config extends Backbone.Model

	url: -> "#{baseUrl}/data/config.json"

	getCdnUrl: ->
		majorVersion = pck.version.split(".")[0]
		"//cdn.huygens.knaw.nl/elaborate/publication/#{@get('templateName')}/v#{majorVersion}"
	
	defaults: ->
		templateName: "collection"
		annotationsIndexPath: "#{baseUrl}/data/annotation_index.json"
		baseUrl: baseUrl
		appRootElement: '#app'
		entryTermSingular: 'entry'
		entryTermPlural: 'entries'
		searchPath: "api/search"
		resultRows: 25
		timbuctooBase: " https://test.repository.huygens.knaw.nl/v2/"
		timbuctooPerson: "domain/cnwpersons/"
		VRE_ID: "CNW"
		isLetterFacetedSearchLoaded: false

		roles:
			'READER': 10
			'USER': 20
			'PROJECTLEADER': 30
			'ADMIN': 40

		# Attribute to check which layer the user has clicked in a text layer.
		# The attribute is sanitized in @set from "Critical annotations" to "critical"
		# Used in elaborate-modules/views/panels/index
		activeTextLayerId: null

		# Attribute to track if the layer the user clicked is an annotations layer.
		# Set to true when during sanitation of activeTextLayerId the last part of the
		# layer was " annotations".
		# Used in elaborate-modules/views/panels/index
		activeTextLayerIsAnnotationLayer: null

	initialize: ->
		@on 'change:isLetterFacetedSearchLoaded', =>
			Backbone.trigger "letter-faceted-search-loaded"
			
		@on 'change:title', =>
			# Set the page title. Use document.title to ensure IE compatibility.
			document.title = @get 'title'

	parse: (data) ->
		for entry in data.entries
			entry._id = +entry.datafile.replace '.json', '' 
			entry.thumbnails = data.thumbnails[entry._id]

		tls = []
		tls.push id: textlayer for textlayer in data.textLayers
		data.textlayers = tls

		data

	set: (attrs, options) ->
		sanitizeTextLayer = (textLayer) =>
			splitLayer = textLayer.split(' ')
			if splitLayer[splitLayer.length - 1] is 'annotations'
				splitLayer.pop()
				textLayer = splitLayer.join(' ')
				@set 'activeTextLayerIsAnnotationLayer', true
			else
				@set 'activeTextLayerIsAnnotationLayer', false

			us.slugify textLayer

		if attrs is 'activeTextLayerId' and options?
			options = sanitizeTextLayer options
		else if attrs.hasOwnProperty 'activeTextLayerId' and attrs.activeTextLayerId?
			attrs.activeTextLayerId = sanitizeTextLayer attrs[activeTextLayerId]

		super

	slugToLayer: (slug) ->
		for layer in @get('textLayers') || []
			if slug is us.slugify layer
				return layer

module.exports = new Config