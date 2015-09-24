module.exports =
	str: (str) ->
		### Escape a regular expression ###
		escapeRegExp: -> str.replace /[-\/\\^$*+?.()|[\]{}]/g, '\\$&'

		# Capitalize the first letter of a string
		ucfirst: -> str.charAt(0).toUpperCase() + str.slice(1)

		# Slugify a string
		slugify: ->
			from = "àáäâèéëêìíïîòóöôùúüûñç·/_:;"
			to   = "aaaaeeeeiiiioooouuuunc-----"

			str = str.trim().toLowerCase()
			strlen = str.length

			while strlen--
				index = from.indexOf str[strlen]

				if index isnt -1
					str = str.substr(0, strlen) + to[index] + str.substr(strlen + 1)

			str.replace(/[^a-z0-9 -]/g, '')
				.replace(/\s+|\-+/g, '-')
				.replace(/^\-+|\-+$/g, '')

		toElement: ->
			div = document.createElement('div')
			div.innerHTML = str
			div.firstChild