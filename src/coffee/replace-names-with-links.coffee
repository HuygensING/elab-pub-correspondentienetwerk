_createLink = (name) ->
	"<span class=\"link\">#{name}</span>"

module.exports = (title, createLink) ->
	unless createLink?
		createLink = _createLink

	[zenders, ontvangers] = title.split(" aan ")
	[ontvangers, datum] = ontvangers.split(" | ")

	originalOntvangers = ontvangers

	splitters = ["/", "-->"]

	for splitter in splitters
		if ontvangers.indexOf(splitter) isnt -1
			ontvangers = ontvangers.split(splitter)
			for ontvanger, i in ontvangers
				ontvangers[i] = createLink(ontvanger)

			ontvangers = ontvangers.join(splitter)

	if ontvangers is originalOntvangers
		ontvangers = createLink ontvangers

	createLink(zenders) + " aan " + ontvangers + " | " + datum