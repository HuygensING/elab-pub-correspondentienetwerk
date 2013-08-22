module.exports = (grunt) ->

	##############
	### CONFIG ###
	##############

	grunt.initConfig
		shell:
			'mocha-phantomjs': 
				command: 'mocha-phantomjs -R dot http://localhost:8000/.test/index.html'
				options:
					stdout: true
					stderr: true

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

		watch:
			coffee:
				files: 'src/**/*.coffee'
				tasks: 'coffee:compile'

	#############
	### TASKS ###
	#############

	grunt.loadNpmTasks 'grunt-shell'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-watch'

	grunt.registerTask 'init', [
		'coffee:compile'
	]