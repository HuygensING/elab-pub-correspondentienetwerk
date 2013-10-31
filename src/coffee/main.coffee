require.config 
	paths:
		'json3': '../lib/json3/lib/json3.min'
		'jquery': '../lib/jquery/jquery'
		'jquery-visible': '../lib/jquery.visible/jquery.visible.min'
		'jquery-ui': '../lib/jquery-ui/ui'
		'unsemantic-html5shim': '../lib/unsemantic/assets/javascripts/html5'
		'underscore': '../lib/underscore-amd/underscore'
		'backbone': '../lib/backbone-amd/backbone'
		'domready': '../lib/requirejs-domready/domReady'
		'text': '../lib/requirejs-text/text'
		'managers': '../lib/managers/dev'
		'helpers': '../lib/helpers/dev'
		'html': '../html'

	shim:
		'underscore':
			exports: '_'
		'backbone':
			deps: ['underscore', 'jquery', 'json3']
			exports: 'Backbone'
		'jquery-ui':
			exports: '$'
			deps: ['jquery']
		'jquery-visible': ['jquery']
		'unsemantic-html5shim':
			exports: 'this'

require ['util/html5shiv', 'json3', 'domready', 'config', 'app', 'unsemantic-html5shim'], (html5shiv, json3, domready, config, app) ->
	domready ->
		# Doing this here before Backbone starts parsing stuff
		window.JSON = json3

		app.initialize()