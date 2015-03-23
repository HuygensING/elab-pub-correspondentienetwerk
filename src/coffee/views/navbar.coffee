Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'

config = require '../models/config'

entries = require '../collections/entries'

util = require 'funcky.util'

fStr = require('funcky.str').str
fEl = require('funcky.el').el

thumbnailTpl = require '../../jade/entry/thumbnail.jade'

class NavBar extends Backbone.View

	tagName: 'nav'

	# ### Initialize
	initialize: (@options={}) ->
		@loadedThumbnails = []
		@unloadedThumbnails = []
		@render()

	# ### Render
	render: ->
		@thumbnailsUL = document.createElement('ul')
		@thumbnailsUL.className = 'thumbnails'

#		@throttledOnScroll = _.throttle(@loadThumbnails.bind(@), 1000, trailing: false)
		@throttledOnScroll = (ev) => util.setResetTimeout 100, @onNavScroll.bind(@)
		@thumbnailsUL.addEventListener 'scroll', @throttledOnScroll

		renderThumbnail = (entry) =>
			unless entry instanceof entries.model
				entry = entries.findWhere '_id': entry.id

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

		collection = if config.get('facetedSearchResponse') then config.get('facetedSearchResponse').get('results') else entries.models
		collection.map renderThumbnail

		@el.appendChild @thumbnailsUL

		for i in [0...40]
			@loadThumbnail @thumbnailsUL.children[i], i

		@activateThumb()

		# Setting to the end of the event stack (setTimeout fun, 0) doesn't
		# work when navigating from annotation overview to entry. With 100ms
		# extra, it does work.
		# console.log 'calling'
		# setTimeout @onNavScroll.bind(@), 100

		@

	# Method called when the <ul> is scrolled horizontally.
	# Loads a thumbnail when no thumbnails are being loaded and
	# a thumbnail is visible in the viewport.
	# onNavScroll: do ->
	# 	loading = false

	# 	->
	# 		unless loading
	# 			# Find the first unloaded thumbnail that is visible in the viewport.
	# 			li = _.find @unloadedThumbnails, (l) -> 
	# 				fEl(l).inViewport()

	# 			unless li?
	# 				return console.log('done')

	# 			loading = true

	# 			onLoad = =>
	# 				loading = false

	# 				if @unloadedThumbnails.length is 0
	# 					@el.querySelector('ul').removeEventListener 'scroll', @throttledOnScroll

	# 				if @unloadedThumbnails[0]? and fEl(@unloadedThumbnails[0]).inViewport()
	# 					@loadThumbnail @unloadedThumbnails.shift(), onLoad

	# 				# Run loadThumbnails again, because when the scroll ends,
	# 				# the next li could be in the viewport.
	# 				# console.log 'call onnavscroll'
	# 				@onNavScroll()

	# 			@loadThumbnail li, onLoad

	onNavScroll: ->
		li = _.find @unloadedThumbnails, (l) -> 
			fEl(l).inViewport()

		index = @unloadedThumbnails.indexOf li

		load = (index) =>
			if @unloadedThumbnails[index]? and not @unloadedThumbnails[index].loaded
				@loadThumbnail @unloadedThumbnails[index], i
				@unloadedThumbnails[index].loaded = true

		load(i) for i in [index..(index - 4)]
		load(i) for i in [(index + 1)..(index + 40)]

	loadThumbnail: (li, index) ->
		# The img tag is already present in the <li>, because
		# otherwise the CSS fade in (opacity transition) wouldn't work.
		img = li.querySelector('img')
		
		onLoad = ->
			img.style.opacity = 1
			imgDone()

		onError = ->
			img.src = notFoundUrl
			imgDone()

		imgDone = =>
			# Get the index of the li and remove.
			# index = @unloadedThumbnails.indexOf li
			# @unloadedThumbnails.splice index, 1

			img.removeEventListener 'load', onLoad
			img.removeEventListener 'error', onError

		# Listen to load and error events.
		img.addEventListener 'load', onLoad
		img.addEventListener 'error', onError

		# Add the src to the image.
		notFoundUrl = "#{config.getCdnUrl()}/images/not-found.svg"
		img.src = li.getAttribute('data-src') ? notFoundUrl 

	# ### Events
	events: ->
		'click li': 'navigateEntry'

	# ### Methods
	destroy: ->
		@thumbnailsUL.removeEventListener @throttledOnScroll
		
		@remove()

	activateThumb: (entryId) ->
		$entries = @$ 'ul.thumbnails'

		# If no entryId is given, use the current entry id.
		entryId ?= entries.current.get("_id")

		# Unactivate current active entry.
		$entries.find('li.active').removeClass 'active'

		# Add active to activated entry.
		$active = $entries.find "li#entry-#{entryId}"
		$active.addClass 'active'

		# Using jQuery with .position().left does not give the correct left, because I guess it does not use
		# $entries as the parent to calculate relative left.
		leftPos = fEl($active[0]).position($entries[0]).left
		offset = ($(window).width()/2) - ($active.width()/2)

		leftPos = $active[0].offsetLeft
		# Animate entry to center.
		@$('.thumbnails').animate
			scrollLeft: leftPos - offset
		, 300

	navigateEntry: (ev) ->
		if ev.hasOwnProperty 'currentTarget'
			entryId = ev.currentTarget.id.replace("entry-", "")
		else
			entryId = ev

		# Animate the NavBar.
		@activateThumb entryId

		# Change the current entry.
		@trigger 'change:entry', entryId: entryId
		Backbone.history.navigate "/entry/#{entryId}"

module.exports = NavBar