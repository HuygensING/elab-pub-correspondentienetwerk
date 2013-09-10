define (require) ->
	configData = require 'models/configdata'
	config = require 'config'
	BaseView = require 'views/base'

	Templates =
		Text: require 'text!html/text.html'

	class TextView extends Backbone.View
		initialize: ->
			@template = _.template Templates.Text
			@render()

		setView: (version) ->
			@currentTextVersion = version
			@renderContent()

		renderAnnotations: ->
			annotations = @model.annotations @currentTextVersion
			tmpl = _.template Templates.Annotations
			@$('.annotations .padder').html tmpl annotations: annotations
			@

		renderContent: ->
			text = @model.text @currentTextVersion
			@$('.text').html text
			@renderAnnotations()

			@

		render: ->
			@$el.html @template()