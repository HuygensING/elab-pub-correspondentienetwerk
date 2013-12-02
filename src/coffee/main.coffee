require.config 
	paths:
		'json3': '../lib/json3/lib/json3.min'
		'jquery': '../lib/jquery/jquery'
		'jquery.scrollTo': '../lib/jquery.scrollTo/jquery.scrollTo.min'
		'jquery-ui': '../lib/jquery-ui/ui'
		'unsemantic-html5shim': '../lib/unsemantic/assets/javascripts/html5'
		'underscore': '../lib/underscore-amd/underscore'
		'underscore.string': '../lib/underscore.string/lib/underscore.string'
		'backbone': '../lib/backbone-amd/backbone'
		'domready': '../lib/requirejs-domready/domReady'
		'text': '../lib/requirejs-text/text'
		'faceted-search': '../lib/faceted-search'
		'managers': '../lib/managers/dev'
		'helpers': '../lib/helpers/dev'
		'html': '../html'
		'rangy': '../lib/rangy'

	shim:
		'underscore':
			exports: '_'
		'underscore.string':
			exports: '_'
			deps: ['underscore']
		'backbone':
			deps: ['underscore', 'jquery', 'json3']
			exports: 'Backbone'
		'jquery-ui':
			exports: '$'
			deps: ['jquery']
		'jquery-visible': ['jquery']
		'rangy/rangy-core':
			exports: 'rangy'
		'rangy/rangy-cssclassapplier':
			exports: 'rangy'
			deps: ['rangy/rangy-core']
		'unsemantic-html5shim':
			exports: 'this'
		'jquery.scrollTo':
			deps: ['jquery']
			exports: '$'

require ['util/html5shiv', 'json3', 'domready', 'config', 'app', 'unsemantic-html5shim'], (html5shiv, json3, domready, config, app) ->
	domready ->
		# Doing this here before Backbone starts parsing stuff
		window.JSON = json3

		app.initialize()