require.config({
	baseUrl: '/.test/',
	paths: {
		mocha: 'lib/mocha',
		chai: '/.test/lib/chai',
		_: '/.test/lib/underscore',
		jquery: '/.test/lib/jquery-1.9.1'
	}
});

require(['require', 'mocha', '_'], function(require)  {
	mocha.setup('bdd');

	require(['/.test/tests.js'], function() {
		if (window.mochaPhantomJS) { mochaPhantomJS.run(); }
		else { mocha.run(); }
	});
});