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
		'./src/stylus/**/*.styl'
	]

cssFiles = [
	"./compiled/css/src.css"
	"./node_modules/hibb-faceted-search/dist/main.css"
]

gulp.task 'server', ->
	browserSync.init null,
		server:
			baseDir: baseDir
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
		.pipe(concat("src.css"))
		.pipe(gulp.dest(devDir+'/css'))

gulp.task 'css', ['stylus'], ->
	gulp.src(cssFiles)
		.pipe(concat("main-#{context.VERSION}.css"))
		.pipe(gulp.dest("#{devDir}/css"))
		.pipe(browserSync.reload(stream: true))

gulp.task 'uglify', ->
	gulp.src("#{devDir}/js/*")
	.pipe(concat("main.js", newLine: '\r\n;'))
	.pipe(uglify())
	.pipe(gulp.dest(prodDir+'/js/'))

gulp.task 'minify-css', ->
	gulp.src("#{devDir}/css/main-#{context.VERSION}.css")
	.pipe(rename(basename: "main"))
	.pipe(minifyCss())
	.pipe(gulp.dest(prodDir+'/css'))

gulp.task 'clean-compiled', -> gulp.src(devDir+'/*').pipe(clean())
gulp.task 'clean-dist', -> gulp.src(prodDir+'/*').pipe(clean())

gulp.task 'copy-static-compiled', -> gulp.src('./static/**/*').pipe(gulp.dest(devDir))
gulp.task 'copy-static-dist', -> gulp.src('./static/**/*').pipe(gulp.dest(prodDir))

gulp.task 'copy-images-compiled', ['copy-static-compiled'], -> 
gulp.task 'copy-images-dist', ['copy-static-dist'], ->

gulp.task 'copy-index', -> gulp.src(devDir+'/index.html').pipe(gulp.dest(prodDir))

gulp.task 'compile', ['clean-compiled'], ->
	gulp.start 'copy-images-compiled', 'browserify-libs', 'browserify', 'jade', 'css'

gulp.task 'build', ['clean-dist'], ->
	gulp.start 'copy-images-dist'
	gulp.start 'copy-index'
	gulp.start 'uglify'
	gulp.start 'minify-css'
	
gulp.task 'watch', ->
	gulp.watch ['./src/index.jade'], ['jade']
	gulp.watch [paths.stylus], ['css']

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

gulp.task 'default', ['css', 'server', 'watch', 'watchify']