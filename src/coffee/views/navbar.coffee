Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'

config = require '../models/config'

entries = require '../collections/entries'

util = require '../funcky/util'

fStr = require('../funcky/str').str
fEl = require('../funcky/el').el

thumbnailTpl = require '../../jade/entry/thumbnail.jade'

async = require 'async'

class NavBar extends Backbone.View

	tagName: 'nav'

	# ### Initialize
	initialize: (@options={}) ->
		@loading = false
		@initialSearchChange = true
		@loadedThumbnails = []
		@unloadedThumbnails = []
		@thumbnailsUL = document.createElement('ul')
		@thumbnailsUL.className = 'thumbnails'

		@listenTo config, "change:facetedSearchResponse", =>
			if @initialSearchChange == true
				@initialSearchChange = false
			else
				@loadedThumbnails = []
				@unloadedThumbnails = []
				@render()

		@render()

	# ### Render
	render: ->
		$(@thumbnailsUL).html("")

		renderThumbnail = (entry) =>
			unless entry instanceof entries.model
				entry = entries.findWhere '_id': parseInt(entry)

			if(entry)
				id = entry.get('_id')

				# Create an HTML element from the thumbnail template.
				# First the template string is generated and second
				# the element created fromt the string.
				tplStr = thumbnailTpl
					src: entry.get('thumbnails')[0]
					id: "entry-" + entry.get("_id")
					name: entry.get('shortName') ? id
				thumb = fStr(tplStr).toElement()
				thumb.loaded = false

				@unloadedThumbnails.push thumb
				# Append the thumb element to the fragment.
				@thumbnailsUL.appendChild thumb

		collection = if config.get('facetedSearchResponse') then config.get('facetedSearchResponse').attributes.ids else entries.models
		collection.map renderThumbnail

		@el.appendChild @thumbnailsUL

		@activateThumb()

		@

	_listenToScroll: ->
		@thumbnailsUL = @el.querySelector 'ul'

		@throttledOnScroll = (ev) => util.setResetTimeout 100, @onNavScroll.bind(@)
		@thumbnailsUL.addEventListener 'scroll', @throttledOnScroll

	onNavScroll: ->
		return if @loading

		@loading = true
		
		li = _.find @unloadedThumbnails, (l) -> 
			fEl(l).inViewport()

		index = @unloadedThumbnails.indexOf li

		@loadThumbnailsAtIndex index, =>
			@loading = false

	loadThumbnailsAtIndex: do ->
		firstCall = true

		(index, done) ->
			async.each [(index - 30)..(index + 30)], @loadThumbnailAtIndex, =>
				done() if done?

				setTimeout (=>	
					if firstCall
						firstCall = false
						@_listenToScroll()
				), 1000

	loadThumbnailAtIndex: (index, done) =>
		if @unloadedThumbnails[index]? and not @unloadedThumbnails[index].loaded
			@loadThumbnail @unloadedThumbnails[index], done
			@unloadedThumbnails[index].loaded = true
		else
			done()

	loadThumbnail: (li, done) ->
		# The img tag is already present in the <li>, because
		# otherwise the CSS fade in (opacity transition) wouldn't work.
		img = li.querySelector('img')
		
		# Handle succesful loading.
		onLoad = ->
			img.style.opacity = 1
			imgDone()

		# Handle loading errors.
		onError = ->
			img.src = notFoundUrl || ""
			imgDone()

		# Remove event listeners and call the callback.
		imgDone = =>
			img.removeEventListener 'load', onLoad
			img.removeEventListener 'error', onError

			done()

		# Listen to load and error events.
		img.addEventListener 'load', onLoad
		img.addEventListener 'error', onError

		# Add the src to the image.
		img.src = li.getAttribute('data-src') ? "" 

	# ### Events
	events: ->
		'click li': 'navigateEntry'

	# ### Methods
	destroy: ->
		@thumbnailsUL.removeEventListener @throttledOnScroll
		
		@remove()

	activateThumb: (entryId, scroll = false) ->

		# If no entryId is given, use the current entry id.
		entryId ?= entries.current.get("_id")

		index = entries.indexOf entries.get(entryId)
		if config.get('facetedSearchResponse') 
			index = config.get('facetedSearchResponse').attributes.ids.indexOf("" + entryId)

		@loading = true
		@loadThumbnailsAtIndex index, =>
			# Unactivate current active entry.
			$entries = @$ 'ul.thumbnails'
			$entries.find('li.active').removeClass 'active'

			# Add active to activated entry.
			$active = $entries.find "li#entry-#{entryId}"
			$active.addClass 'active'

			# Using jQuery with .position().left does not give the correct left, because I guess it does not use
			# $entries as the parent to calculate relative left.
			leftPos = 0
			offset = 0
			if $active[0]
				leftPos = fEl($active[0]).position($entries[0]).left
				offset = ($(window).width()/2) - ($active.width()/2)
				leftPos = $active[0].offsetLeft

			if scroll
				@$('.thumbnails').animate
						scrollLeft: leftPos - offset
					, 300
			else
				@$('.thumbnails')[0].scrollLeft = leftPos - offset
			
			@loading = false

	navigateEntry: (ev) ->
		if ev.hasOwnProperty 'currentTarget'
			entryId = ev.currentTarget.id.replace("entry-", "")
		else
			entryId = ev

		# Animate the NavBar.
		@activateThumb entryId, true

		# Change the current entry.
		@trigger 'change:entry', entryId: entryId
		Backbone.history.navigate "/entry/#{entryId}"

module.exports = NavBar