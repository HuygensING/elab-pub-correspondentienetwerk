# UP FOR REMOVAL!

define (require) ->
	Fn = require 'helpers2/general'

	validator: (args) ->
		{valid, invalid} = args

		# A validate function we're adding to every model instance we're listening to
		validate = (attrs, options) ->
			invalids = []

			# Flatten attributes, because nested attributes must also be targeted by a string (<input name="namespace.level.level2"> for namespace: {level: {level2: 'some value'}})
			flatAttrs = Fn.flattenObject(attrs)

			# Loop the validation settings
			for own attr, settings of @validation

				# Don't validate empty strings which are not required
				if not settings.required and flatAttrs[attr].length isnt 0
					# Turn into switch or hash with functions?
					if settings.pattern? and settings.pattern is 'number'
						unless /^\d+$/.test flatAttrs[attr]
							invalids.push
								attr: attr
								msg: 'Please enter a valid number.'

			# Return invalids array if populated, otherwise return nothing (and Backbone can continue with setting the model)
			if invalids.length then return invalids else return

		# Are we listening to a model or a collection?
		# Add the validate function to (all) the model(s)
		if @model?
			listenToObject = @model
			@model.validate = validate
		else if @collection?
			listenToObject = @collection
			@collection.each (model) =>
				model.validate = validate

			# Add validate function to models which are added dynamically
			@listenTo @collection, 'add', (model, collection, options) => model.validate = validate
		else
			console.error "Validator mixin: no model or collection attached to view!"
			return

		# Create a hash that keeps track of all the attributes that triggered the 'invalid' event.
		# When an attribute changes (succesful validation and model.set) and the changed attribute is present in @invalidAttrs (the attr was previously invalid), we have to call the valid callback
		@invalidAttrs = {}

		# Listen to 'invalid' event, populate @invalidAttrs and call the invalid callback
		@listenTo listenToObject, 'invalid', (model, errors, options) =>
			_.each errors, (error) =>
				# Trigger isInvalid on the first occurance of an invalid attribute
				@trigger 'validator:invalidated' unless _.size(@invalidAttrs)
				
				@invalidAttrs[error.attr] = error
				invalid model, error.attr, error.msg
		
		# Using the valid function would be very nice, but does not work in practice
		# When default value for an attribute is "" (an empty string) and the user changes it from something invalid
		# back to an empty string (which could be valid), the model's change event is not triggered, because the value did
		# not change "" => "". Same goes for valid => invalid => valid (12 => /?#not12@llowed => 12), the value changes
		# from 12 to 12 and thus no change event is triggered.
		#
		# Best setup is to use the invalid callback to set invalid class and remove invalid class in the view on change
		if valid?
			# Listen to change event to call the valid callback on previously invalid attributes
			@listenTo listenToObject, 'change', (model, options) =>
				flatChangedAttrs = Fn.flattenObject model.changedAttributes()

				for own attr of flatChangedAttrs
					if @invalidAttrs.hasOwnProperty attr
						valid model, attr
						delete @invalidAttrs[attr]

						# Trigger isValid when there are no more invalid attributes
						@trigger 'validator:validated' unless _.size(@invalidAttrs)