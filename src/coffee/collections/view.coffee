define (require) ->
	Backbone = require 'backbone'

	class Views extends Backbone.Collection
		
		has: (view) -> 
			if this.get(view.cid) then true else false