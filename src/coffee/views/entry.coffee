Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'

config = require 'elaborate-modules/modules/models/config'

entries = require 'elaborate-modules/modules/collections/entries'

dom = require 'hilib/src/utils/dom'

fStr = require('funcky.str').str
fEl = require('funcky.el').el


Views =
	Panels: require 'elaborate-modules/modules/views/panels'
	NavBar: require './navbar'

preloader = require './preloader'

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
		navBar = new Views.NavBar()
		@el.appendChild navBar.el

		@renderPanels @options

		@

	renderPanels: do -> 
		panels = null

		(options) ->
			panels.destroy() if panels?
			panels = new Views.Panels options
			@$el.append panels.$el

	# ### Methods
	destroy: ->
		view.destroy() for view in @subviews
		@remove()

module.exports = Entry