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

			@textVersion = @options?.textVersion || 'Translation'

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

		positionSelectionTab: ->
			ml = @$('.selection').outerWidth() / 2
			mt = @$('.selection').outerHeight()
			@$('.selection').css
				left: '50%'
				'margin-left': "-#{ml}px"
				'margin-top': "-#{mt}px"

		renderCurrentSelection: ->
			@$('.selection .current span').text @textVersion

		renderContent: ->
			if @versionIsFacsimile()
				@subView = new FacsimileView
					model: @model, page: @page
				@$('.view').html @subView.el
			else
				@subView = new TextView
					model: @model
					version: @textVersion
				@$('.view').html @subView.el

		render: ->
			@$el.html @template
				entry: @model?.attributes
				versions: _.flatten [ 'Facsimile', @model.textVersions() ]
				version: @textVersion
			@renderCurrentSelection()
			@renderContent()
			@$el.addClass config.panelSize
			@positionSelectionTab()

			@