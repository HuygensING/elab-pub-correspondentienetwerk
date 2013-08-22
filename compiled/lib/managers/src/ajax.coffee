define (require) ->
	$ = require 'jquery'
	$.support.cors = true

	token: null

	get: (args) ->
		@fire 'get', args

	post: (args) ->
		@fire 'post', args

	put: (args) ->
		@fire 'put', args

	fire: (type, args) ->
		ajaxArgs =
			type: type
			dataType: 'json'
			contentType: 'application/json; charset=utf-8'
			processData: false
			crossDomain: true

		if @token?
			ajaxArgs.beforeSend = (xhr) => xhr.setRequestHeader 'Authorization', "SimpleAuth #{@token}"

		$.ajax $.extend ajaxArgs, args