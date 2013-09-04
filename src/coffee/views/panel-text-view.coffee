define (require) ->

	Templates =
		PanelTextView: require 'text!html/panel-text.html'

	class PanelTextView extends Backbone.View
		initialize: ->
			@render() if @model
		render: ->
			template = _.template Templates.PanelTextView
			@$el.html template
				item: @model.attributes
				version: @options.version || "Translation"