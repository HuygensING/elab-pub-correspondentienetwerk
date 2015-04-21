_createLink = (name) ->
	postfix = ""

	if name.indexOf('#') > -1
		[name, postfix] = name.split("#")
		postfix = "##{postfix}"

	"<span class=\"link\">#{name}</span>#{postfix}"

_split = (data, splitter, createLink) ->
	if data.indexOf(splitter) isnt -1
		data = data.split(splitter)
		for d, i in data
			data[i] = createLink(d)

		data = data.join(splitter)
	
	data
	
module.exports = (title, createLink) ->
	console.log title
	unless createLink?
		createLink = _createLink

	[zenders, ontvangers] = title.split(" aan ")
	[ontvangers, datum] = ontvangers.split(" | ")

	originalOntvangers = ontvangers
	originalZenders = zenders

	for splitter in ["/", "-->"]
		zenders = _split zenders, splitter, createLink
		ontvangers = _split ontvangers, splitter, createLink

	if ontvangers is originalOntvangers
		ontvangers = createLink ontvangers

	if zenders is originalZenders
		zenders = createLink zenders

	zenders + " aan " + ontvangers + " | " + datum