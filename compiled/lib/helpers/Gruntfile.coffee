fs = require 'fs'
path = require 'path'

connect_middleware = (connect, options) ->
	[
		(req, res, next) ->
			contentTypesMap =
				'.html': 'text/html'
				'.css': 'text/css'
				'.js': 'application/javascript'
				'.map': 'application/javascript' # js source maps
				'.gif': 'image/gif'
				'.jpg': 'image/jpeg'
				'.jpeg': 'image/jpeg'
				'.png': 'image/png'
				'.ico': 'image/x-icon'
			
			sendFile = (reqUrl) ->
				filePath = path.join options.base, reqUrl
				
				res.writeHead 200,
					'Content-Type': contentTypesMap[extName] || 'text/html'
					'Content-Length': fs.statSync(filePath).size

				readStream = fs.createReadStream filePath
				readStream.pipe res
			
			extName = path.extname req.url

			if contentTypesMap[extName]?
				sendFile req.url
			else
				sendFile 'index.html'
	]

module.exports = (grunt) ->

	##############
	### CONFIG ###
	##############

	grunt.initConfig
		shell:
			mocha: 
				command: 'mocha-phantomjs -R dot http://localhost:8000/.test/index.html'
				options:
					stdout: true
					stderr: true

		connect:
			test:
				options:
					port: 8000
					base: ''
					middleware: connect_middleware
					# keepalive: true

		coffee:
			compile:
				files: [
					expand: true
					cwd: 'src'
					src: '**/*.coffee'
					dest: 'dev'
					rename: (dest, src) -> 
						dest + '/' + src.replace(/.coffee/, '.js') # Use rename to preserve multiple dots in filenames (nav.user.coffee => nav.user.js)
				]
			test:
				options:
					bare: true
					join: true
				files: 
					'.test/tests.js': ['.test/head.coffee', 'test/**/*.coffee']

		watch:
			coffee:
				files: 'src/**/*.coffee'
				tasks: 'coffee:compile'
			coffeetest:
				files: 'test/**/*.coffee'
				tasks: ['coffee:test']

	#############
	### TASKS ###
	#############

	grunt.loadNpmTasks 'grunt-shell'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-connect'

	# grunt.registerTask 't', ['connect:test', 'shell:mocha']
	grunt.registerTask 'sw', ['connect:test', 'w']
	grunt.registerTask 'w', 'watch'
	grunt.registerTask 'init', [
		'coffee:compile'
	]