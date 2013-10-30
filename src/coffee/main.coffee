require.config 
	paths:
		'json3': '../lib/json3/lib/json3.min'
		'jquery': '../lib/jquery/jquery'
		'jquery-ui': '../lib/jquery-ui/ui'
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

require ['json3', 'domready', 'config', 'app'], (json3, domready, config, app) ->
	domready ->
		window.JSON = json3
		app.initialize()