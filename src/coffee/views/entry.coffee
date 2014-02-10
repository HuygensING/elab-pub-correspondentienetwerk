Backbone = require 'backbone'
$ = require 'jquery'

config = require 'elaborate-modules/modules/models/config'

entries = require 'elaborate-modules/modules/collections/entries'

dom = require 'hilib/src/utils/dom'

Views =
	Panels: require 'elaborate-modules/modules/views/panels'

preloader = require './preloader'

headerTpl = require '../../jade/entry/header.jade'
thumbnailTpl = require '../../jade/entry/thumbnail.jade'


class Entry extends Backbone.View

	className: 'entry'

	# ### Initialize
	initialize: (@options={}) ->
		super

		@subviews = []

		modelLoaded = =>		
			entries.setCurrent @model.id
			@el.setAttribute 'id', 'entry-'+@model.id
			@render()

		if config.get('facetedSearchResponse')? and config.get('facetedSearchResponse').get('ids').length < entries.length
			part = config.get('facetedSearchResponse').get('ids').length + ' of ' + entries.length
			$('a[name="entry"]').html "Edition <small>(#{part})</small>"
		else
			$('a[name="entry"]').html "Edition"

		# The IDs of the entries are passed to the collection on startup, so we can not check
		# isNew() if we need to fetch the full model or it already has been fetched.
		if @model = entries.get @options.entryId
			modelLoaded()
		else
			@model = if @options.entryId? then entries.findWhere datafile: @options.entryId+'.json' else entries.current

			@model.fetch().done => modelLoaded()

	# ### Render
	render: ->
		@$el.html @renderHeader()

		@renderPanels @options

		@renderEntries()

		@

	renderHeader: ->
		header = document.createElement 'header'

		header.innerHTML = headerTpl
			entryTermSingular: config.get('entryTermSingular')
			entry: @model
			resultIds: config.get('facetedSearchResponse')?.get('ids') ? []
			entries: entries

		header


	renderEntries: ->
		loadedImages = $.Deferred()
		loadedImages
			.then( =>
				@$('.loader').hide()
				@$('ul.entries').fadeIn 150
			).then( =>
				@activateThumb()
			)

		# start loading the images
		thumbsLoaded = 0
		imageLoaded = =>
			thumbsLoaded++
			loadedImages.resolve() if thumbsLoaded >= (thumbCount / 2) or thumbsLoaded > 30
			loadedImages.resolve() if thumbsLoaded >= thumbCount

		frag = document.createDocumentFragment()

		renderThumbnail = (id, name) =>
			thumbUrl = config.get('thumbnails')[id]?[0]
			preloader.loadImage thumbUrl, imageLoaded

			re = /nota\s?\w+/
			# console.log entry.get('name')
			thumb = $ thumbnailTpl
				id: id
				thumbnail: thumbUrl ? "http://placehold.it/70x100/000000/000000&text=X"
				# href: entry.createUrl()
				index: re.exec(name)[0].substr(4)

			thumb.find('img').load imageLoaded
			frag.appendChild thumb[0]

		if config.get('facetedSearchResponse')?
			thumbCount = config.get('facetedSearchResponse').get('results').length
			renderThumbnail result.id, result.name for result in config.get('facetedSearchResponse').get('results')
		else
			thumbCount = entries.length
			renderThumbnail result.get('_id'), result.get('name') for result in entries.models

		@$('ul.entries').html frag


	renderPanels: do -> 
		panels = null

		(options) ->
			panels.destroy() if panels?
			panels = new Views.Panels options
			@$el.append panels.$el

	# ### Events
	events: ->
		'click ul.entries li': 'navigateEntry'

	# ### Methods
	destroy: ->
		view.destroy() for view in @subviews
		@remove()

	activateThumb: (entryId) ->
		$entries = @$ 'ul.entries'

		# If no entryId is given, use the current entry id.
		entryId = entryId ? entries.current.get('_id')

		# Unactivate current active entry.
		$entries.find('li.active').removeClass 'active'

		# Add active to activated entry.
		$active = $entries.find 'li[data-entry-id="'+entryId+'"]'
		$active.addClass 'active'

		# Using jQuery with .position().left does not give the correct left, because I guess it does not use
		# $entries as the parent to calculate relative left.
		leftPos = dom($active[0]).position($entries[0]).left
		offset = ($(window).width()/2) - ($active.width()/2)

		# Animate entry to center.
		@$('.entries').animate
			scrollLeft: leftPos - offset
		, 150

	navigateEntry: (ev) ->
		entryId = ev.currentTarget.getAttribute 'data-entry-id'

		@activateThumb entryId
		@renderPanels entryId: entryId
		Backbone.history.navigate "/entry/#{entryId}"

module.exports = Entry