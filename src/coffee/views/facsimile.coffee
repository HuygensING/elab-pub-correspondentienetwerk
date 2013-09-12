define (require) ->
	class Facsimile extends Backbone.View
		initialize: ->
			@size = @options.size || 'large'
			@render()

		render: ->
			@$el.html "<img src='#{@model.facsimileURL(size: @size)}' alt='Facsimile view' class='#{@size}'>"
			@$('img').css width: '100%'