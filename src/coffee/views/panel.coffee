define (require) ->
	config = require 'config'
	Entry = require 'models/entry'

	TextView = require 'views/text'
	FacsimileView = require 'views/facsimile'

	# jq = require 'jquery-ui/jquery-ui'

	class PanelView extends Backbone.View
		className: 'panel-frame'
		template: require 'text!html/panel.html'
		events:
			'click .selection li': 'selectText'

		initialize: (@options) ->
			@template = _.template @template

			@textVersion = @options?.textVersion
			@versions = @options.versions

			if 'id' of @options and not @model
				@model = new Entry id: @options.id
				@model.fetch success: => @render()
			else if @model
				@render()

		selectText: (e) ->
			target = $(e.currentTarget)
			@setVersion target.data 'toggle'

		versionIsFacsimile: -> @textVersion is 'Facsimile'

		# Page is only relevant if version is 'Facsimile'
		setVersion: (version, page=null) ->
			@textVersion = version
			@page = page if @versionIsFacsimile()
			@renderContent()

		selectedVersion: -> @textVersion

		renderCurrentSelection: ->
			@$('.selection .current span').text @textVersion

		renderContent: ->
			if @versionIsFacsimile()
				@subView = new FacsimileView
					model: @model, page: @page
				@$('.view').html @subView.el
			else
				if @textVersion
					@subView = new TextView
						model: @model
						version: @textVersion
					@$('.view').html @subView.el

		render: ->
			@$el.html @template
				entry: @model?.attributes
				versions: @versions
				version: @textVersion

			@$el.toggleClass 'select', not @textVersion?

			@renderCurrentSelection()
			@renderContent()
			@$el.addClass config.panelSize

			@