Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'

config = require 'elaborate-modules/modules/models/config'

entries = require 'elaborate-modules/modules/collections/entries'

dom = require 'hilib/src/utils/dom'
util = require 'hilib/src/utils/general'

fStr = require('funcky.str').str
fEl = require('funcky.el').el

thumbnailTpl = require '../../jade/entry/thumbnail.jade'


class NavBar extends Backbone.View

	tagName: 'nav'

	# ### Initialize
	initialize: (@options={}) ->
		@unloadedThumbnails = []
		@render()

	# ### Render
	render: ->
		ul = document.createElement('ul')
		ul.className = 'thumbnails'

#		@throttledOnScroll = _.throttle(@loadThumbnails.bind(@), 1000, trailing: false)
		@throttledOnScroll = (ev) => util.timeoutWithReset 100, @onNavScroll.bind(@)
		ul.addEventListener 'scroll', @throttledOnScroll

		renderThumbnail = (entry) =>
			unless entry instanceof entries.model
				entry = entries.findWhere '_id': entry.id

			id = entry.get('_id')

			# Create an HTML element from the thumbnail template.
			# First the template string is generated and second
			# the element created fromt the string.
			tplStr = thumbnailTpl
				src: entry.get('thumbnails')[0]
				index: entries.indexOf(entry)
				name: entry.get('shortName') ? id
			thumb = fStr(tplStr).toElement()

			@unloadedThumbnails.push thumb
			# Append the thumb element to the fragment.
			ul.appendChild thumb

		collection = if config.get('facetedSearchResponse') then config.get('facetedSearchResponse').get('results') else entries.models
		collection.map renderThumbnail

		@el.appendChild ul

		# Setting to the end of the event stack (setTimeout fun, 0) doesn't
		# work when navigating from annotation overview to entry. With 100ms
		# extra, it does work.
		setTimeout @onNavScroll.bind(@), 100

		@

	# Method called when the <ul> is scrolled horizontally.
	# Loads a thumbnail when no thumbnails are being loaded and
	# a thumbnail is visible in the viewport.
	onNavScroll: do ->
		loading = false

		->
			unless loading
				# Find the first unloaded thumbnail that is visible in the viewport.
				li = _.find @unloadedThumbnails, (li) -> fEl(li).inViewport()
				return unless li?

				# Get the index of the li and remove.
				index = @unloadedThumbnails.indexOf li
				@unloadedThumbnails.splice index, 1

				loading = true

				load = (li) =>
					@loadThumbnail li, =>
						loading = false

						if @unloadedThumbnails.length is 0
							@el.querySelector('ul').removeEventListener 'scroll', @throttledOnScroll

						if @unloadedThumbnails[0]? and fEl(@unloadedThumbnails[0]).inViewport()
							load @unloadedThumbnails.shift()


						# Run loadThumbnails again, because when the scroll ends,
						# the next li could be in the viewport.
						@onNavScroll()

				load(li)

	loadThumbnail: (li, done) ->
		# The img tag is already present in the <li>, because
		# otherwise the CSS fade in (opacity transition) wouldn't work.
		img = li.querySelector('img')

		img.addEventListener 'load', =>
			# Fade in the thumbnail, using CSS.
			img.style.opacity = 1

			done()

		img.src = li.getAttribute('data-src')

	# ### Events
	events: ->
		'click li': 'navigateEntry'

	# ### Methods
	destroy: ->
		@remove()

	activateThumb: (entryIndex) ->
		$entries = @$ 'ul.thumbnails'

		# If no entryId is given, use the current entry id.
		entryIndex = entryIndex ? entries.indexOf(entries.current)

		# Unactivate current active entry.
		$entries.find('li.active').removeClass 'active'

		# Add active to activated entry.
		$active = $entries.find 'li[data-index="'+entryIndex+'"]'
		$active.addClass 'active'

		# Using jQuery with .position().left does not give the correct left, because I guess it does not use
		# $entries as the parent to calculate relative left.
		leftPos = dom($active[0]).position($entries[0]).left
		offset = ($(window).width()/2) - ($active.width()/2)

		# Animate entry to center.
		@$('.thumbnails').animate
			scrollLeft: leftPos - offset
		, 300

	navigateEntry: (ev) ->
		# Animate the NavBar.
		index = ev.currentTarget.getAttribute 'data-index'
		@activateThumb index

		# Change the current entry.
		entry = entries.at index
		@trigger 'change:entry', entryId: entry.get('_id')
		Backbone.history.navigate "/entry/#{entry.get('_id')}"

module.exports = NavBar