require.config({
	baseUrl: '/.test/',
	paths: {
		mocha: 'lib/mocha',
		chai: 'lib/chai',
		jquery: 'lib/jquery-1.9.1'
	}
});

require(['require', 'mocha'], function(require)  {
	mocha.setup('bdd');

	require(['/.test/tests.js'], function() {
		if (window.mochaPhantomJS) { mochaPhantomJS.run(); }
		else { mocha.run(); }
	});
});