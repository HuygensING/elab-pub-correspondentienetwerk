define (require) ->
	$ = require 'jquery'

	# Capitalize the first letter of a string 
	ucfirst: (str) -> str.charAt(0).toUpperCase() + str.slice(1)

	###
	Slugify a string
	###
	slugify: (str) ->
		from = "àáäâèéëêìíïîòóöôùúüûñç·/_:;"
		to   = "aaaaeeeeiiiioooouuuunc-----"
		
		str = str.trim().toLowerCase()
		strlen = str.length

		while strlen--
			index = from.indexOf str[strlen]
			str = str.substr(0, strlen) + to[index] + str.substr(strlen + 1) if index isnt -1

		str.replace(/[^a-z0-9 -]/g, '')
			.replace(/\s+|\-+/g, '-')
			.replace(/^\-+|\-+$/g, '')

	###
	Strips the tags from a string
	
	Example: "This is a <b>string</b>." => "This is a string."
	
	return String
	###
	stripTags: (str) ->
		$('<span />').html(str).text()

	###
	Removes non numbers from a string
	
	Example: "There are 12 monkeys." => "12"
	
	return String
	###
	onlyNumbers: (str) ->
		str.replace /[^\d.]/g, ''