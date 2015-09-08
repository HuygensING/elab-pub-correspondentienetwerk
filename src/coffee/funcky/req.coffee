# WIP
module.exports =
	get: (url, options={}) ->
		@_sendRequest 'GET', url, options

	post: (url, options={}) ->
		@_sendRequest 'POST', url, options

	put: (url, options={}) ->
		@_sendRequest 'PUT', url, options

	_promise: ->
		done: (fn) -> @callDone = fn
		callDone: null
		fail: (fn) -> @callFail = fn
		callFail: null
		always: (fn) -> @callAlways = fn
		callAlways: null

	_sendRequest: (method, url, options={}) ->
		promise = @_promise()

		options.headers ?= {}

		xhr = new XMLHttpRequest()

		xhr.onreadystatechange = ->
			if xhr.readyState is 4
				promise.callAlways xhr if promise.callAlways?
				if 200 <= xhr.status <= 206 or xhr.status is 1223
					promise.callDone xhr if promise.callDone?
				else
					promise.callFail xhr if promise.callFail?


		xhr.open method, url, true

		xhr.setRequestHeader "Content-type", "application/json"
		for own header, value of options.headers
			xhr.setRequestHeader header, value
	
		xhr.send options.data

		promise