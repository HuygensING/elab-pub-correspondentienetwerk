define (require) ->
	chai = require 'chai'
	
	# Libs
	$ = require 'jquery'

	# Files
	mixin = require '/dev/jquery.mixin.js'
	Fn = require '/dev/fns.js'

	chai.should()