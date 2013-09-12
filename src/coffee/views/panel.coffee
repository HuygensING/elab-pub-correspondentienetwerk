define (require) ->
	config = require 'config'
	Item = require 'models/item'

	TextView = require 'views/text'
	FacsimileView = require 'views/facsimile'

	jq = require 'jquery-ui/jquery-ui'

	class PanelView extends Backbone.View
		className: 'panel'
		template: require 'text!html/panel.html'
		events:
			'click .selection li': 'selectText'

		initialize: ->
			@template = _.template @template

			@textVersion = @options?.textVersion || 'Translation'

			if 'id' of @options and not @model
				@model = new Item id: @options.id
				@model.fetch success: => @render()
			else if @model
				@render()

		selectText: (e) ->
			target = $(e.currentTarget)
			@textVersion = target.data 'toggle'
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
			if @textVersion is 'Facsimile'
				@subView = new FacsimileView model: @model
				@$('.view').html @subView.el
			else
				@subView = new TextView
					model: @model
					version: @textVersion
				@$('.view').html @subView.el

		render: ->
			@$el.html @template
				item: @model?.attributes
				versions: _.flatten [ 'Facsimile', @model.textVersions() ]
				version: @textVersion
			@renderCurrentSelection()
			@renderContent()
			@$el.addClass config.panelSize
			@positionSelectionTab()

			@