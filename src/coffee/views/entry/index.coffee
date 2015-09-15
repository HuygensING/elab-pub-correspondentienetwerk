Backbone = require 'backbone'
_ = require 'underscore'
$ = require 'jquery'

config = require '../../models/config'

entries = require '../../collections/entries'
persons = require '../../collections/persons'

replaceNamesWithLinks = require '../../replace-names-with-links'

Views =
	# Panels: require './panels'
	NavBar: require '../navbar'

tpl = require './index.jade'
thumbnailsIconTpl = require './thumbnails-icon.jade'

class Entry extends Backbone.View

	className: 'entry'

	# ### Initialize
	initialize: (@options={}) ->
		super

		@subviews = []

		@listenTo config, "change:facetedSearchResponse", ->
			if config.get('facetedSearchResponse')? and config.get('facetedSearchResponse').get('ids').length < entries.length
				part = config.get('facetedSearchResponse').get('ids').length + ' of ' + entries.length
				$('a[name="entry"]').html "Editie <small>(#{part})</small>"
			else
				$('a[name="entry"]').html "Editie"

		@render @options.entryId

	_loadModel: (id, done) ->
		# The IDs of the entries are passed to the collection on startup, so we can not check
		# isNew() if we need to fetch the full model or it already has been fetched.
		if @model = entries.get id
			entries.setCurrent @model.id
			@el.setAttribute 'id', 'entry-'+@model.id
			done()
		else
			@model = if id? then entries.findWhere datafile: id+'.json' else entries.current

			# If a model isn't found (user has typed or pasted something wrong), go Home.
			Backbone.history.navigate '/', trigger:true unless @model?

			@model.fetch().done =>
				entries.setCurrent @model.id
				@el.setAttribute 'id', 'entry-'+@model.id
				done()

	# ### Render
	render: (id) ->
		unless @navBar?
			@navBar = new Views.NavBar()
			@el.appendChild @navBar.el

			article = document.createElement 'article'
			@el.appendChild article

			@listenTo @navBar, 'change:entry', (data) =>
				@render data.entryId

		@_loadModel id, =>
			text = @model.get("paralleltexts")["Transcription"].text

			# Doing this to ensure empty lines get correct height, so as not to mess with line numbering
			if text?
				text = String(text).replace /<div class="line">\s*<\/div>/mg, '<div class="line">&nbsp;</div>'


			@$("article").html tpl
				model: @model
				text: text
				title: replaceNamesWithLinks @model.get('name')

			bs = []
			for b, i in @el.querySelectorAll('b')
				b.title = @model.get("facsimiles")[i].title
				b.className = "set-facsimile"
				b.setAttribute "data-index", i
				if b.innerHTML is "¶"
					bs.push(b)

			prevBottom = 0
			for b, i in bs
				figure = document.createElement "figure"
				figure.title = @model.get("facsimiles")[i].title

				img = document.createElement "img"
				img.src = @model.get("facsimiles")[i].thumbnail
				img.className = "thumbnail"
				img.setAttribute "data-index", i

				figcaption = document.createElement "figcaption"
				figcaption.innerHTML = @model.get("facsimiles")[i].title


				figure.appendChild img
				figure.appendChild figcaption

				b.parentNode.insertBefore figure, b.nextSibling
				b.innerHTML = thumbnailsIconTpl()
				rect = figure.getBoundingClientRect()
				delta = rect.top - prevBottom
				if delta < 0
					figure.style.top = -delta + "px"
					rect = figure.getBoundingClientRect()
					
				prevBottom = rect.top + rect.height + 10

		@

	events: ->
		"click b.set-facsimile": "_handleChangeFacsimile"
		"click img.thumbnail": "_handleChangeFacsimile"
		"click button.toggle-metadata": -> @$(".metadata .table-container").slideToggle("fast")
		"click h2 span.link": "_handleSearchPerson"

	_handleSearchPerson: (ev) ->
		person = persons.findWhere koppelnaam: $.trim(ev.currentTarget.innerHTML)
		Backbone.history.navigate "person/#{person.id}", trigger: true

	_handleChangeFacsimile: (ev) ->
		index = ev.currentTarget.getAttribute("data-index")
		iframe = @el.querySelector ".facsimile iframe"
		iframe.src = @model.get("facsimiles")[index].zoom

	changeEntry: (id) ->
		

	# ### Methods
	destroy: ->
		view.destroy() for view in @subviews
		@remove()

module.exports = Entry