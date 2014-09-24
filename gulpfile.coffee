gulp = require 'gulp'
gutil = require 'gulp-util'
jade = require 'gulp-jade'
concat = require 'gulp-concat'
clean = require 'gulp-clean'
stylus = require 'gulp-stylus'
rename = require 'gulp-rename'
uglify = require 'gulp-uglify'
minifyCss = require 'gulp-minify-css'
preprocess = require 'gulp-preprocess'

browserSync = require 'browser-sync'
modRewrite = require 'connect-modrewrite'

browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'

exec = require('child_process').exec
async = require 'async'
rimraf = require 'rimraf'
rsync = require("rsyncwrapper").rsync
nib = require 'nib'
pkg = require './package.json'
cfg = require './config.json'

devDir = './compiled'
prodDir = './dist'

baseDir = if process.env.NODE_ENV is 'prod' then prodDir else devDir
env = if process.env.NODE_ENV is 'prod' then 'production' else 'development'

context =
	VERSION: pkg.version
	ENV: env
	BASEDIR: baseDir

paths =
	stylus: [
		'./node_modules/hilib/src/views/**/*.styl'
		'./node_modules/huygens-faceted-search/src/stylus/**/*.styl'
		'./node_modules/elaborate-modules/modules/**/*.styl'
		'./src/stylus/**/*.styl'
	]

gulp.task 'link', (done) ->
	removeModules = (cb) ->
		modulePaths = cfg['local-modules'].map (module) -> "./node_modules/#{module}"
		async.each modulePaths , rimraf, (err) -> cb()

	linkModules = (cb) ->
		moduleCommands = cfg['local-modules'].map (module) -> "npm link #{module}"
		async.each moduleCommands, exec, (err) -> cb()

	async.series [removeModules, linkModules], (err) ->
		return gutil.log err if err?
		done()

gulp.task 'unlink', (done) ->
	unlinkModules = (cb) ->
		moduleCommands = cfg['local-modules'].map (module) -> "npm unlink #{module}"
		async.each moduleCommands, exec, (err) -> cb()

	installModules = (cb) ->
		exec 'npm i', cb

	async.series [unlinkModules, installModules], (err) ->
		return gutil.log err if err?
		done()

gulp.task 'server', ->
	baseDir = process.env.NODE_ENV ? 'compiled'

	browserSync.init null,
		server:
			baseDir: "./#{baseDir}"
			middleware: [
				modRewrite([
					'^[^\\.]*$ /index.html [L]'
				])
			]
		notify: false

gulp.task 'jade', ->
	gulp.src('./src/index.jade')
		.pipe(jade())
		.pipe(preprocess(context: context))
		.pipe(gulp.dest(devDir))
		.pipe(browserSync.reload(stream: true))

gulp.task 'stylus', ->
	gulp.src(paths.stylus)
		.pipe(stylus(
			use: [nib()]
			errors: true
		))
		.pipe(concat("main-#{context.VERSION}.css"))
		.pipe(gulp.dest(devDir+'/css'))
		.pipe(browserSync.reload(stream: true))


gulp.task 'uglify', ->
	gulp.src("#{devDir}/js/*")
	.pipe(concat("main.js", newLine: '\r\n;'))
	.pipe(uglify())
	.pipe(gulp.dest(prodDir+'/js/'))

gulp.task 'minify-css', ->
	gulp.src("#{devDir}/css/main-#{context.VERSION}.css")
	.pipe(rename(basename: 'main'))
	.pipe(minifyCss())
	.pipe(gulp.dest(prodDir+'/css'))

gulp.task 'clean-compiled', -> gulp.src(devDir+'/*').pipe(clean())
gulp.task 'clean-dist', -> gulp.src(prodDir+'/*').pipe(clean())

gulp.task 'copy-static-compiled', -> gulp.src('./static/**/*').pipe(gulp.dest(devDir))
gulp.task 'copy-static-dist', -> gulp.src('./static/**/*').pipe(gulp.dest(prodDir))

gulp.task 'copy-images-compiled', ['copy-static-compiled'], -> gulp.src('./node_modules/hilib/images/**/*').pipe(gulp.dest(devDir+'/images/hilib'))
gulp.task 'copy-images-dist', ['copy-static-dist'], -> gulp.src('./node_modules/hilib/images/**/*').pipe(gulp.dest(prodDir+'/images/hilib'))

gulp.task 'copy-index', -> gulp.src(devDir+'/index.html').pipe(gulp.dest(prodDir))

gulp.task 'compile', ['clean-compiled'], ->
	gulp.start 'copy-images-compiled', 'browserify-libs', 'browserify', 'jade', 'stylus'

gulp.task 'build', ['clean-dist'], ->
	gulp.start 'copy-images-dist'
	gulp.start 'copy-index'
	gulp.start 'uglify'
	gulp.start 'minify-css'
	
gulp.task 'watch', ->
	gulp.watch ['./src/index.jade'], ['jade']
	gulp.watch [paths.stylus], ['stylus']

createBundle = (watch=false) ->
	args =
		entries: './src/coffee/main.coffee'
		extensions: ['.coffee', '.jade']

	bundler = if watch then watchify(args) else browserify(args)

	bundler.transform('coffeeify')
	bundler.transform('jadeify')
	bundler.transform('envify')

	bundler.exclude 'jquery'
	bundler.exclude 'underscore'
	bundler.exclude 'backbone'

	rebundle = ->
		gutil.log('Watchify: start rebundling') if watch
		bundler.bundle()
			.pipe(source("src-#{context.VERSION}.js"))
			.pipe(gulp.dest(devDir+'/js'))
			.pipe(browserSync.reload(stream: true, once: true))

	bundler.on 'update', rebundle

	rebundle()

gulp.task 'browserify', -> createBundle false
gulp.task 'watchify', -> createBundle true

gulp.task 'browserify-libs', ->
	libs =
		underscore: './node_modules/underscore/underscore'
		jquery: './node_modules/jquery/dist/jquery'
		backbone: './node_modules/backbone/backbone'

	libPaths = Object.keys(libs).map (key) ->
		libs[key]

	bundler = browserify libPaths

	for own id, path of libs
		bundler.require path, expose: id

	gutil.log('Browserify: bundling libs')
	bundler.bundle()
		.pipe(source("libs-#{context.VERSION}.js"))
		.pipe(gulp.dest(devDir+'/js'))

gulp.task 'default', ['stylus', 'server', 'watch', 'watchify']